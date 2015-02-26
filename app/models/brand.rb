class Brand < ActiveRecord::Base
	self.primary_key = :Brand
	
	def Brand.seedfromCSV	# assumes the CSV file to be in "db/preseeds/Brands.csv"
		require 'csv'
		Brand.delete_all
		insertString = CSV.read("db/preseeds/Brands.csv").map {|brand| "('#{brand[0]}')"}.join(', ')
		Brand.connection.execute("INSERT INTO brands (Brand) VALUES #{insertString}")
	end
end
