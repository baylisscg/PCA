#

source :rubygems

# This is a Rails 3 app
gem "rails", ">=3.0.0"

gem "rails3-generators"

gem "rake"
gem "sinatra"
gem "nokogiri"

#gem "oauth-plugin", ">=0.4.0.pre1"

group :production do

  gem "warbler"

end

# We need rspec-rails here right now
group :development do

  gem "rspec-rails"

  gem "yard"

  gem "bluecloth" unless RUBY_PLATFORM == 'java'

  if RUBY_PLATFORM == "java"
    gem "trinidad"
  else
    gem "thin"
  end

end

group :test do
  gem "rspec-rails" # rspec-rails isn't needed here but my be later.
  gem "webrat", "0.7.1" # Webrat 0.7.2 doesn't work with RSpec
  gem "factory_girl_rails"
  gem "faker"
  gem "machinist"
end

gem "delayed_job"
gem 'delayed_job_mongoid'

if RUBY_PLATFORM =~ /java/ then
  # Load pure Ruby or JRuby specific libraries
  gem "mongo"
  gem "bson"
  gem "jruby-openssl"
  gem "mongrel"
else
   # Load libraries with C extensions.
   gem "mongo_ext"
   gem "bson_ext"
end

gem "mongoid", ">=2.0.0.rc.7"

# used by workers
gem "httpclient"
