source "http://www.rubygems.org"

# This is a Rails 3 app
gem "rails", ">=3.0.0"

gem "rails3-generators"

#gem "oauth-plugin", ">=0.4.0.pre1"

# We need rspec-rails here right now
group :development do
  gem "faker"
  gem "rspec-rails", ">= 2.0.0.beta.22"
end

group :test do
  gem "rspec-rails", ">= 2.0.0.beta.22" # rspec-rails isn't needed here but my be later.
  gem "webrat", "0.7.1" # Webrat 0.7.2 doesn't work with RSpec
#  gem "factory_girl", "~> 2.0.0.beta1"
  gem "factory_girl_rails"
end

gem "delayed_job", ">=2.1.0.pre2"
gem 'delayed_job_mongoid', '1.0.0.rc'

if RUBY_PLATFORM =~ /java/ then
  # Load pure Ruby or JRuby specific libraries
  gem "mongo"
  gem "bson"
  gem "jruby-openssl",">=0.7.1"
  gem "mongrel"

  # Grab warbler to convert Rails -> WAR servlet
  group :development do
    gem "warbler"
  end
else
   # Load libraries with C extensions.
   gem "mongo_ext"
   gem "bson_ext"
end

gem "mongoid", ">=2.0.0.beta.20"

# used by workers
gem "httpclient"
