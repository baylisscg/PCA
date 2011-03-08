require 'machinist/mongoid'
require 'sham'
require 'faker'

Dir["#{Rails.root}/spec/blueprints/**/*_blueprint.rb"].each do |f| 
  puts "require #{f}"
  require f
end

Sham.name { Faker::Name.name }



