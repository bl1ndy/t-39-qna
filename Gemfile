# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'aws-sdk-s3', '~> 1.114', require: false
gem 'bootsnap', '>= 1.4.4', require: false
gem 'cocoon', '~> 1.2', '>= 1.2.15'
gem 'devise', '~> 4.8', '>= 4.8.1'
gem 'jbuilder', '~> 2.7'
gem 'jquery-rails', '~> 4.5'
gem 'net-smtp', require: false
gem 'pg', '~> 1.4', '>= 1.4.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.6'
gem 'sass-rails', '>= 6'
gem 'slim-rails', '~> 3.5', '>= 3.5.1'
gem 'turbolinks', '~> 5'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'webpacker', '~> 5.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 6.2'
  gem 'rspec-rails', '~> 5.1.2'
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'rubocop', '~> 1.30', '>= 1.30.1', require: false
  gem 'rubocop-performance', '~> 1.14', '>= 1.14.2', require: false
  gem 'rubocop-rails', '~> 2.14', '>= 2.14.2', require: false
  gem 'rubocop-rspec', '~> 2.12', '>= 2.12.1', require: false
  gem 'spring'
  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'launchy', '~> 2.5'
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.5'
  gem 'selenium-devtools', '~> 0.104.0'
  gem 'selenium-webdriver', '>= 4.0.0.rc1'
  gem 'shoulda-matchers', '~> 5.1'
  gem 'webdrivers'
end
