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
	end
end

namespace :jobs do
	namespace :work do
		
	end
end