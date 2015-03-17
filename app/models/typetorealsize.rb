class Typetorealsize < ActiveRecord::Base
	
	self.primary_key = :T2RS_ID
#	attr_accessor :T2RS_ID, :BrandStyleMaterial, :ToMondo1, :ToMondo0, :modified, :Uncertainty
	has_many :shoes, primary_key: "T2RS_ID", foreign_key: "T2RS_ID"

	def Typetorealsize.update_entry(_t2rsid)
		Typetorealsize.find_by_T2RS_ID!(_t2rsid).update_entry
	end

	def update_entry
		row_limit = 30
		c0, c1, err = self.ToMondo0, self.ToMondo1, self.Uncertainty

		entry_info = Shoe.all.where(T2RS_ID: self.T2RS_ID).includes(:owner).limit(row_limit)

		if entry_info.distinct.count(:PreSize) >= 2
			preshoe = entry_info.map{|s| [1.0, s.PreSize, s.PreSize*s.PreSize, s.owner.ShoeSize, s.PreSize*s.owner.ShoeSize]}
			x0, x1, x2, yx0, yx1 = preshoe.transpose.map{|l| l.sum}
			recip = 1.0/(x2*x0 - x1*x1)

			# update coefficients to a weighted average of the current coefficients and some 'ideal' coefficients
			c0 = 0.25*(3.0*c0 + (+x2*yx0 - x1*yx1)*recip)
			c1 = 0.25*(3.0*c1 + (-x1*yx0 + x0*yx1)*recip)
			# err = Math.sqrt(preshoe.sum{|s| (s[3]-s[1])*(s[3]-s[1])}/preshoe.count)
			# not updating Uncertainty here because it happens later in T2RS#update
		end

		self.update!(ToMondo1: c1, ToMondo0: c0, Uncertainty: err)
	end

	def Typetorealsize.update
		Customer.emptyShoeSizeSweep()

		affShoes = Shoe.all.includes(:owner, :typetorealsize).where(typetorealsizes: {modified: true}).references(:typetorealsizes)
		
		# affShoes.group('"T2RS_ID"').each do |shoe|
		# 	shoe.typetorealsize.update_entry
		# end

		affShoes.select(:T2RS_ID).uniq.each do |shoe|
			shoe.typetorealsize.update_entry
		end

		# affShoes.pluck(:T2RS_ID, :ShoeID).each do |entry|	# update shoes' realSizes
		# 	shoe = Shoe.find_by_ShoeID(entry[1])
		# 	shoe.update!(RealSize: Shoe.preToRealSize(entry[0], shoe.preRealSize))
		# end

		affShoes.each do |shoe|
			# shoe.update!(RealSize: Shoe.preToRealSize(shoe.T2RS_ID, shoe.preRealSize))
			shoe.update_RealSize!
		end

		# affShoes.pluck(:OwnerID).uniq.each do |ownerid|	# update details of owners with affected shoes
		# 	Customer.updateStats(ownerid)
		# end

		affShoes.select(:OwnerID).uniq.each do |shoe|	# update stats of owners with affected shoes
			shoe.owner.updateStats
		end

		# affShoes.pluck(:T2RS_ID).uniq.each do |t2rsid|	# update T2RS error values
		# 	Typetorealsize.find_by_T2RS_ID(t2rsid).update!(Uncertainty: affShoes.where(T2RS_ID: t2rsid).pluck("\"RealSize\"-\"ShoeSize\"").extend(DescriptiveStatistics).standard_deviation)
		# end

		affShoes.select(:T2RS_ID).uniq.each do |shoe|	# update T2RS error values
			arr = affShoes.where(T2RS_ID: shoe.T2RS_ID).pluck(:RealSize, :ShoeSize)
			shoe.typetorealsize.update!(Uncertainty: Math.sqrt(arr.sum{|e| (e[0]-e[1])*(e[0]-e[1])}/arr.count), modified: false)
		end
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
end