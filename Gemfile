source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem 'jquery-rails'

gem 'pg'
gem 'devise'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'twitter'
gem 'subdomainbox'
gem 'uuidtools'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'therubyracer', :require => 'v8'
  gem 'less-rails-bootstrap', '2.0.13'
end

group :development, :test, :staging do
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-stack_explorer'
end

group :development, :test do
  gem 'rspec-rails', '2.10.1'
  gem 'jasmine'
  gem 'jasminerice'
  gem 'awesome_print'
end

group :test do
  gem 'launchy'
  gem 'spork', '>= 0.9.2'
  # Factory Girl 2.4.1 was creating duplicates, so when we did
  # 3.times { Factory(:document, :asset_library => @library) }
  # expecting the library to have 3 documents, we actually ended up with 6
  gem 'factory_girl', '2.2.0'
  gem 'factory_girl_rails'
  gem 'fuubar'
  gem 'capybara', '1.1.2'
  gem 'database_cleaner'
end
