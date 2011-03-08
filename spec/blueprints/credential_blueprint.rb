#
#
#

Sham.valid_from(:unique=>false) { Time.now - ( 60**2*24*(365 - rand(364))) }
Sham.valid_to(:unique=>false)   { Time.now + ( 60**2*24*(365 - rand(364))) }

Credential.blueprint do
  valid_from
  valid_to
end

