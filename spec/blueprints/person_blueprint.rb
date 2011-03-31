#
#
#

require 'uri'

Sham.first_name { Faker::Name.first_name }
Sham.last_name  { Faker::Name.last_name  }

Person.blueprint do

  first_name
  last_name
  url { URI::HTTPS.build( :host=>"user.example.org",:path=>"/#{last_name}_#{first_name}").to_s }

end
