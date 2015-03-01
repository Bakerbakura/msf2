class Typetorealsize < ActiveRecord::Base
	require 'descriptive_statistics'

	self.primary_key = :T2RS_ID
#	attr_accessor :T2RS_ID, :BrandStyleMaterial, :ToMondo1, :ToMondo0, :modified, :Uncertainty
	has_many :shoes, primary_key: "T2RS_ID", foreign_key: "T2RS_ID"

	def Typetorealsize.update_entry(_t2rsid)
		row_limit = 30
		c0, c1 = 0.0, 1.0
		t2rs_entry = Typetorealsize.find_by_T2RS_ID(_t2rsid)
		brand, style, material = t2rs_entry.BrandStyleMaterial.split('|')
		
		T2rsEntryInfo.delete_all
		T2rsEntryInfo.connection.execute("INSERT INTO t2rs_entry_infos(\"OwnerID\", \"PreSize\", \"RealSize\", \"ShoeSize\")
			SELECT shoes.\"OwnerID\", shoes.\"preRealSize\", shoes.\"RealSize\", customers.\"ShoeSize\" FROM customers, shoes
			WHERE shoes.\"Brand\" = '#{brand}' AND shoes.\"Style\" = '#{style}' AND shoes.\"Material\" = '#{material}' AND shoes.\"OwnerID\" = customers.\"CustID\"")
		t2rs_entry_info = T2rsEntryInfo.all.limit(row_limit)
		ndiff = t2rs_entry_info.distinct.count(:PreSize)

		if ndiff >= 2 # calculate relevant numbers
			preshoe = t2rs_entry_info.all.map{|s| [s.PreSize, s.PreSize*s.PreSize, s.ShoeSize, s.PreSize*s.ShoeSize]}
			x0, x1, x2, y0, y1 = [preshoe.count] + preshoe.transpose.map{|l| l.sum}	# + is array concatenation - did this way for more succinct syntax
			err = preshoe.map{|s| s[2]-s[0]}.extend(DescriptiveStatistics).standard_deviation
			
			# update coefficients to a weighted average of the current coefficients and some 'ideal' coefficients
			c0 = 0.25*(c0 + 3.0*(+x2*y0 - x1*y1))
			c1 = 0.25*(c1 + 3.0*(-x1*y0 + x0*y1))
		end

		t2rs_entry.update!(ToMondo1: c1, ToMondo0: c0, Uncertainty: err, modified: false)
	end

	def Typetorealsize.update
		Customer.emptyShoeSizeSweep()

		AffectedShoe.delete_all
		AffectedShoe.connection.execute("INSERT INTO affected_shoes(\"ShoeID\", \"OwnerID\", \"T2RS_ID\", \"RealSize\", \"ShoeSize\")
			SELECT shoes.\"ShoeID\", shoes.\"OwnerID\", T2RS.\"T2RS_ID\", shoes.\"RealSize\", customers.\"ShoeSize\" FROM shoes, typetorealsizes AS T2RS, customers
			WHERE T2RS.modified = TRUE AND T2RS.\"T2RS_ID\" = shoes.\"T2RS_ID\" AND shoes.\"OwnerID\" = customers.\"CustID\"")
		affShoes = AffectedShoe.all
		
		affShoes.pluck(:T2RS_ID).uniq.each do |t2rsid|	# update each T2RS entry with correct conversion factors
			Typetorealsize.update_entry(t2rsid)
		end

		affShoes.pluck(:T2RS_ID, :ShoeID).each do |entry|	# update shoes' realSizes
			shoe = Shoe.find_by_ShoeID(entry[1])
			shoe.update!(RealSize: Shoe.preToRealSize(entry[0], shoe.preRealSize))
		end

		affShoes.pluck(:OwnerID).uniq.each do |ownerid|	# update details of owners with affected shoes
			Customer.updateShoeStats(ownerid)
		end

		affShoes.pluck(:T2RS_ID).uniq.each do |t2rsid|	# update T2RS Uncertainty coefficients
			# t2rs = Typetorealsize.find_by_T2RS_ID(t2rsid)
			# t2rs.Uncertainty = affShoes.where(T2RS_ID: t2rsid).pluck("\"RealSize\"-\"ShoeSize\"").extend(DescriptiveStatistics).standard_deviation
			# t2rs.save!
			Typetorealsize.find_by_T2RS_ID(t2rsid).update!(Uncertainty: affShoes.where(T2RS_ID: t2rsid).pluck("\"RealSize\"-\"ShoeSize\"").extend(DescriptiveStatistics).standard_deviation)
		end

		AffectedShoe.delete_all
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
	end
end
