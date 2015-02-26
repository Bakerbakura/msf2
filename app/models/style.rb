class Style < ActiveRecord::Base
	self.primary_key = :Style
	
	def Style.seedfromCSV	# assumes the CSV file to be in "db/preseeds/Styles.csv"
		require 'csv'
		Style.delete_all
		insertString = CSV.read("db/preseeds/Styles.csv").map {|style| "('#{style[0]}')"}.join(', ')
		Style.connection.execute("INSERT INTO styles (Style) VALUES #{insertString}")
	end
end
