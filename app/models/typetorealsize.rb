class Typetorealsize < ActiveRecord::Base
	
	self.primary_key = :T2RS_ID
#	attr_accessor :T2RS_ID, :BrandStyleMaterial, :ToMondo1, :ToMondo0, :modified, :Uncertainty
	has_many :shoes, primary_key: "T2RS_ID", foreign_key: "T2RS_ID"

	@@row_limit = 30
	def Typetorealsize.row_limit
		@@row_limit
	end

	def preToRealSize(_preSize)
		return _preSize*self.ToMondo1 + self.ToMondo0
	end

	def Typetorealsize.update_entry(_t2rsid)
		Typetorealsize.find_by_T2RS_ID!(_t2rsid).update_entry
	end

	def update_entry
		c0, c1 = self.ToMondo0, self.ToMondo1

		entry_info = self.shoes.map{|s| [s.preRealSize, s.owner.ShoeSize]}.take(Typetorealsize.row_limit)	# use row_limit here somewhere?
		preSizes = entry_info.map{|e| e[0]}

		if preSizes.uniq.count >= 2 and preSizes.max - preSizes.min >= 30.0
			preshoe = entry_info.map{|e| [1.0, e[0], e[0]*e[0], e[1], e[1]*e[0]]}
			x0, x1, x2, yx0, yx1 = preshoe.transpose.map{|l| l.sum}
			recip = 1.0/(x2*x0 - x1*x1)

			# update coefficients to a weighted average of the current coefficients and some 'ideal' coefficients
			c0 = 0.25*(3.0*c0 + (+x2*yx0 - x1*yx1)*recip)
			c1 = 0.25*(3.0*c1 + (-x1*yx0 + x0*yx1)*recip)
		end

		self.update!(ToMondo1: c1, ToMondo0: c0)
		puts "T2RS entry #{self.T2RS_ID} updated: #{self.BrandStyleMaterial}"
	end

	def Typetorealsize.update
		Customer.emptyShoeSizeSweep()

		affT2RSs = Typetorealsize.all.where(modified: true)
		affShoes = Shoe.all.includes(:typetorealsize).where(typetorealsizes: {modified: true}).references(:typetorealsizes)
			# references needs the actual table name, hence references(:typetorealsizes).
		
		affT2RSs.each {|t2rs| t2rs.update_entry}	# update affected T2RSs' coefficients

		affShoes.each {|shoe| shoe.update_RealSize!}	#update affected shoes' RealSizes

		affShoes.includes(:owner).select(:OwnerID).uniq.each {|shoe| shoe.owner.updateStats}	# update stats of affected owners

		affT2RSs.each do |t2rs|	# update T2RS error values
			arr = t2rs.shoes.map{|s| [s.RealSize, s.preRealSize]}	# use map instead of pluck beacuse t2rs.shoes returns an array, not an AR:Relation
			t2rs.update!(Uncertainty: Math.sqrt(arr.sum{|e| (e[0]-e[1])*(e[0]-e[1])}/arr.count), modified: false)
		end

		puts "Typetorealsize updated!"
	end

	def Typetorealsize.initialise
		Typetorealsize.delete_all
		brands = Brand.pluck(:Brand)
		styles = Style.pluck(:Style)
		materials = Material.pluck(:Material)

		inserts = []
		brands.each do |brand|
			styles.each do |style|
				materials.each do |material|
					inserts.push "(\'#{brand}|#{style}|#{material}\')"
				end
			end
		end
		Typetorealsize.connection.execute("INSERT INTO typetorealsizes (\"BrandStyleMaterial\") VALUES #{inserts.join(', ')}")

		puts "Finished seeding Typetorealsizes table."
	end

	def Typetorealsize.resetCoeffs
		Typetorealsize.all.each do |t2rs|
			t2rs.update!(ToMondo1: 1.0, ToMondo0: 0.0, modified: true)
			t2rs.shoes.each{|s| s.update_attribute(:RealSize, s.preRealSize*t2rs.ToMondo1 + t2rs.ToMondo0)}
			arr = t2rs.shoes.map{|s| [s.preRealSize, s.RealSize]}
			unless arr.empty? then t2rs.update_attribute(:Uncertainty, Math.sqrt(arr.sum{|e| (e[0]-e[1])*(e[0]-e[1])}/arr.count)) end
		end
	end
end