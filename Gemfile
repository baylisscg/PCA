source "http://www.rubygems.org"

# This is a Rails 3 app
gem "rails", ">=3.0.0"

group :test do
  gem "rspec-rails", ">= 2.0.0.beta.22"
end

gem "bunny"

#gem "mongrel"
    		   
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
