class Sizetype < ActiveRecord::Base
	self.primary_key = :SizeType
	
	def Sizetype.seedfromCSV	# assumes the CSV file to be in "db/preseeds/SizeTypes.csv"
		require 'csv'
		Sizetype.delete_all
		insertString = CSV.read("db/preseeds/SizeTypes.csv").map {|st| "('#{st[0]}', #{st[1]}, #{st[2]}, #{st[3]}, #{st[4]}, #{st[5]})"}.join(', ')
		Sizetype.connection.execute("INSERT INTO sizetypes (\"SizeType\", \"ToMondo1\", \"ToMondo0\", \"SizeTypeInterval\", \"MinSize\", \"MaxSize\") VALUES #{insertString}")
	end
end
