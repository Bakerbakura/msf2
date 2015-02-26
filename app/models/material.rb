class Material < ActiveRecord::Base
	self.primary_key = :Material
	
	def Material.seedfromCSV	# assumes the CSV file to be in "db/preseeds/Brands.csv"
		require 'csv'
		Material.delete_all
		insertString = CSV.read("db/preseeds/Materials.csv").map {|material| "('#{material[0]}')"}.join(', ')
		Material.connection.execute("INSERT INTO materials (Material) VALUES #{insertString}")
	end
end
