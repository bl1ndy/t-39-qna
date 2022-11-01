# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'active_model_serializers', '~> 0.10.13'
gem 'aws-sdk-s3', '~> 1.114', require: false
gem 'bootsnap', '>= 1.4.4', require: false
gem 'cocoon', '~> 1.2', '>= 1.2.15'
gem 'devise', '~> 4.8', '>= 4.8.1'
gem 'doorkeeper', '~> 5.6'
gem 'jbuilder', '~> 2.7'
gem 'jquery-rails', '~> 4.5'
gem 'mysql2', '~> 0.5.4'
gem 'net-imap', '~> 0.3.1'
gem 'net-pop', '~> 0.1.2'
gem 'net-smtp', require: false
gem 'oj', '~> 3.13', '>= 3.13.21'
gem 'omniauth', '~> 2.1'
gem 'omniauth-github', '~> 2.0', '>= 2.0.1'
gem 'omniauth-rails_csrf_protection', '~> 1.0', '>= 1.0.1'
gem 'omniauth-vkontakte', '~> 1.8'
gem 'pg', '~> 1.4', '>= 1.4.1'
gem 'puma', '~> 5.0'
gem 'pundit', '~> 2.2'
gem 'rails', '~> 6.1.6'
gem 'sass-rails', '>= 6'
gem 'sidekiq', '~> 6.5', '>= 6.5.7'
gem 'sinatra', '~> 3.0', '>= 3.0.2', require: false
gem 'slim-rails', '~> 3.5', '>= 3.5.1'
gem 'thinking-sphinx', '~> 5.4'
gem 'turbolinks', '~> 5'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'webpacker', '~> 5.0'
gem 'whenever', '~> 1.0', require: false

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 6.2'
  gem 'rspec-rails', '~> 5.1.2'
end

group :development do
  gem 'capistrano', '~> 3.17', '>= 3.17.1', require: false
  gem 'capistrano-bundler', '~> 2.1', require: false
  gem 'capistrano-passenger', '~> 0.2.1', require: false
  gem 'capistrano-rails', '~> 1.6', '>= 1.6.2', require: false
  gem 'capistrano-rbenv', '~> 2.2', require: false
  gem 'capistrano-sidekiq', '~> 2.3'
  gem 'letter_opener', '~> 1.8', '>= 1.8.1'
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
  gem 'capybara-email', '~> 3.0', '>= 3.0.2'
  gem 'database_cleaner-active_record'
  gem 'launchy', '~> 2.5'
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.5'
  gem 'selenium-webdriver', '>= 4.0.0.rc1'
  gem 'shoulda-matchers', '~> 5.1'
  gem 'webdrivers'
end
