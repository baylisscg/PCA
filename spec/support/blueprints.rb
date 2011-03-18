require 'machinist/mongoid'
require 'sham'
require 'faker'

Dir["#{Rails.root}/spec/blueprints/**/*_blueprint.rb"].each do |f| 
  require f
end

