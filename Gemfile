#
#
source :rubygems

  gem "faker"
  gem "machinist"
  gem 'machinist_mongo', :require => 'machinist/mongoid' # or machinist/mongo_mapper


# This is a Rails 3 app
gem "rails", ">=3.0.0"

gem "rake"
gem "nokogiri"
gem "omniauth"

gem "delayed_job"
gem 'delayed_job_mongoid'

if RUBY_PLATFORM =~ /java/ then
  # Load pure Ruby or JRuby specific libraries
  gem "mongo"
  gem "bson"
  gem "jruby-openssl"
else
   # Load libraries with C extensions.
   gem "mongo_ext"
   gem "bson_ext"
end

gem "mongoid", ">=2.0.0.rc.8"

# used by workers
gem "httpclient"


group :production do
  if RUBY_PLATFORM =~ /java/ then
    gem "warbler"
  end
end

# We need rspec-rails here right now
group :development do

  gem "rspec-rails", "~> 2.6.0.rc4"
  gem "yard"
  gem "bluecloth" unless RUBY_PLATFORM == 'java'

  # Select ruby specific test server
  if RUBY_PLATFORM =~ /java/
    gem "trinidad"
  else
    gem "thin"
  end

end

group :test do
  gem "html5"
  gem "rspec-rails", "~> 2.6.0.rc4" # rspec-rails isn't needed here but my be later.
#  gem "shoulda-matchers"
  gem "webrat"
#  gem "faker"
#  gem "machinist"
#  gem 'machinist_mongo', :require => 'machinist/mongoid' # or machinist/mongo_mapper
end

