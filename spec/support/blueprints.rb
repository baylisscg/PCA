#
#
#
#
require 'machinist/mongoid'
require 'sham'
require 'faker'

# Load the blueprints
require "spec/blueprints"

module SpecHelpers
 module Application
   extend ActiveSupport::Concern
   included do
     let!(:params) { Connection.plan }
     let!(:conn) { Connection.make(params) }
   end
 end
end
