source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.7'

# Use SCSS for stylesheets
# gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
# gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 4.1.0'
# Use jquery as the JavaScript library
# gem 'jquery-rails'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# API Gems
gem 'active_model_serializers', '~> 0.8.3'

# Use carrierwave to upload files encoded as base64
gem 'carrierwave-base64'

# Use kaminari for api pagination
gem 'kaminari'
gem 'api-pagination'

# Use foursquare v2 API
gem 'foursquare2'

# Use devise for user authentication
gem "devise"

# API Utilities
gem 'compass-rails', "~> 2.0.2"
gem 'furatto'
gem 'font-awesome-rails'
gem 'simple_form'

# Use puma as the application server
gem 'puma'
gem 'figaro'

group :production do
  gem 'pg'
end

group :development do
  gem 'sabisu_rails', github: "IcaliaLabs/sabisu-rails"
	gem 'sqlite3'
  gem 'spring'
  gem 'capistrano'
  gem 'capistrano3-puma'
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rvm'
end

group :development, :test do
	gem "factory_girl_rails"
	gem "ffaker"
end

group :test do
	gem "rspec-rails", "~> 3.1"
  gem 'shoulda-matchers'
  gem 'database_cleaner'
end




