source 'https://rubygems.org'

# Declare Ruby version
ruby '2.1.5'

# Fix Rails version
# gem 'rails', '4.1.8'
gem 'rails', '~> 4.2.0'	# use to fix rake db:schema:load error on Heroku

# Database
# MySQL
# gem 'mysql2', '~> 0.3.17'
# PostgreSQL
gem 'pg', '~> 0.18.1'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby
# Twitter bootstrap gem
gem 'bootstrap-sass', '~>3.3.3'


# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.0.3'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 2.5.3'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.9'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin]

# Use unicorn as the app server and use recommended 'rails_12factor' gem in Heroku production
group :production do
	gem 'unicorn'
	gem 'rails_12factor'
end

# Populate seeds.rb file from database in development environment
group :development do
	gem 'seed_dump', '~>3.2.1'
end

# Used for statistical calculation purposes
gem 'descriptive_statistics', '~> 2.4.0', :require => 'descriptive_statistics/safe'

# Schedule tasks, especially T2RS.update
gem 'rufus-scheduler', '~> 3.0.9'