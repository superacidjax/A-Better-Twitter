source 'https://rubygems.org'

gem 'bcrypt-ruby'
gem 'bootstrap-sass'
gem 'bootstrap-will_paginate'
gem 'faker'
gem 'hashrocket-rails'
gem 'jquery-rails', '2.0.2'
gem 'pg'
gem 'rails', '3.2.8.rc2'
gem 'rvm-capistrano'
gem 'thin'

group :production do
	gem 'newrelic_rpm'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
	gem 'heroku'
	gem 'pry-nav'
	gem 'pry-rails'
	gem 'rspec-rails'
	gem 'guard-cucumber'
end

group :development do
	gem 'rails-erd'
end

group :test do
	gem 'fabrication'
	gem 'capybara'
	gem 'cucumber-rails', :require => false
	gem 'database_cleaner'
	gem 'growl'
	gem 'guard-rspec'
	gem 'guard-spork'
	gem 'launchy'
	gem 'rb-fsevent', :require => false
	gem 'spork'
end