source 'https://rubygems.org'

ruby '2.3.1'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails'
gem 'bootstrap-sass'
gem 'sqlite3'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'will_paginate-bootstrap'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'puma'
gem 'clearance'
gem 'redcarpet'
gem 'daemons'
gem 'delayed_job_active_record'
gem 'newrelic_rpm'
gem 'sitemap_generator'
gem 'whenever', require: false

group :production do
  gem 'pg'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'guard-rspec', require: false
  gem 'bullet'
end

group :test do
  gem 'rspec-rails'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', require: false
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'faker'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Use Capistrano for deployment
  gem 'capistrano-rails'
  gem 'capistrano3-puma'
  gem 'capistrano3-delayed-job'
  gem 'capistrano-rbenv'
end
