source "http://www.rubygems.org"

# This is a Rails 3 app
gem "rails", ">=3.0.0"

gem "rails3-generators"

# We need rspec-rails here right now
group :development do
  gem "rspec-rails", ">= 2.0.0.beta.22"
end

group :test do
  gem "rspec-rails", ">= 2.0.0.beta.22" # rspec-rails isn't needed here but my be later.
  gem "webrat"
  gem "factory_girl_rails"
end

gem "bunny"
    		   
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

gem "mongoid", ">=2.0.0.beta.19"
