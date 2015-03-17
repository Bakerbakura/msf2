namespace :db do
	namespace :seed do
		desc "Seed brands, styles and materials tables in database from CSV files in db/preseeds"
		task :csv => :environment do
			Brand.seedfromCSV
			Style.seedfromCSV
			Material.seedfromCSV
			Sizetype.seedfromCSV

			puts "Finished seeding from CSV files."
		end

		desc "Generate T2RS table from Brands, Styles and Materials tables"
		task :t2rs => :environment do
			Typetorealsize.initialise

			puts "Finished seeding Typetorealsizes table."
		end
	end
end

namespace :jobs do
	namespace :work do
		
	end
end