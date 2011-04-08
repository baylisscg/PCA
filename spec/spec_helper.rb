# -*- coding: utf-8 -*-
# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

#
# Configure webrat
Webrat.configure do |config|
  config.mode = :rack
end

#Dir["#{File.dirname(__FILE__)}/spec/factories/**/*.rb"].each {|f| require f}


RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  config.include(PCA::Matchers)

  config.before(:all) do 
    Sham.reset(:before_all)
  end
  
  config.before(:each) do
    Sham.reset(:before_each)
  end

  config.mock_with :rspec

  #  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, comment the following line or assign false
  # instead of true.
  #  config.use_transactional_fixtures = true

  # Drop all non system collections
  Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)

end
