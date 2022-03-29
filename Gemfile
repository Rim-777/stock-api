source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.5'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.2', '>= 7.0.2.3'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'api-versions', '~> 1.2', '>= 1.2.1'
gem 'bootsnap', require: false
gem 'dry-validation', '~> 1.8'
gem 'fast_jsonapi', '~> 1.1', '>= 1.1.1'
gem 'kaminari', '~> 0.16.3'
gem 'puma', '~> 5.0'
gem 'rack-cors'
gem 'sentry-raven'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 6.2'
  gem 'rspec-rails', '~> 4.0'
end

group :development do
  gem 'rubocop', require: false
  gem 'spring'
end

group :test do
  gem 'shoulda-matchers', '~> 5.1'
end
