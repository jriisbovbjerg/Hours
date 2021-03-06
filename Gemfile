source "https://rubygems.org"

ruby "2.4.2"

gem "airbrake"
gem "bourbon"
gem "coffee-rails"
gem "delayed_job_active_record", "4.0.3"
gem "email_validator"
gem "flutie"
gem "high_voltage"
gem "jquery-rails", "~> 4.0"
gem "neat"
gem "bitters"
gem "pg"
gem "rack-timeout"
gem "rails", "~> 4.2.10"
gem "recipient_interceptor"
gem "sass-rails", "~> 5.0.1"
gem "simple_form", "~> 3.5.0"
gem "title"
gem "uglifier"
gem "unicorn"
gem "devise", "~> 3.5.2"
gem "devise_invitable", "~> 1.5.5"
gem "apartment", "~> 0.26.0"
gem "pikaday-gem", "~> 1.2.0.0"
gem "momentjs-rails"
gem "gravatar_image_tag"
gem "hashtel", "~> 0.0.2"
gem "kaminari"
gem "select2-rails"
gem "http_accept_language"
gem "normalize-rails"
gem "twitter-text" # hashtag parsing
gem "jquery-atwho-rails", "~> 1.3.2" # autocomplete
gem "haml-rails"
gem "audited-activerecord", "~> 4.0"
gem "paperclip", "~> 6.1.0"
gem "aws-sdk"
gem "redcarpet"
gem "holidays"
gem "sprockets-rails", "~> 2.3"
gem "brakeman"
gem 'money-currencylayer-bank'
gem 'money-rails', '~>1'
gem 'prawn'
gem 'prawn-table'
gem 'responders'

source "https://rails-assets.org" do
  gem "rails-assets-chartjs"
end

# caching

gem "kgio" # faster I/O
gem "dalli" # memcached
gem "memcachier"

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "foreman"
  gem "pry"
  gem "pry-byebug"
  gem "spring"
  gem "spring-commands-rspec"
end

group :development, :test do
  gem "dotenv-rails"
  gem "factory_girl_rails"
  gem "pry-rails"
  gem "rspec-rails", "~> 3.0"
  gem "annotate"
  gem "letter_opener"
  gem "email_spec"
  gem "debase"
  gem "ruby-debug-ide"
end

group :test do
  gem "capybara-webkit", ">= 1.0.0"
  gem "database_cleaner"
  gem "launchy"
  gem "shoulda-matchers", "~> 2.7.0"
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock", ">= 2.3"
end

group :staging, :production do
  gem "newrelic_rpm", ">= 3.7.3"
  gem "rails_12factor"
end
