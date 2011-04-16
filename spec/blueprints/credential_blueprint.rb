#
#
#

Sham.valid_from(:unique=>false) { Time.now - ( 60**2*24*(365 - rand(364))) }
Sham.valid_to(:unique=>false)   { Time.now + ( 60**2*24*(365 - rand(364))) }

Credential.blueprint do
  valid_from
  valid_to
end

Credential.blueprint(:no_time) do
  valid_from { nil }
  valid_to   { nil }
end

Credential.blueprint(:from_only) do
  valid_from { Time.utc(2011) }
  valid_to   { nil }
end

Credential.blueprint(:to_only) do
  valid_from { nil }
  valid_to   { Time.utc(2012) }
end

Credential.blueprint(:to_in_past) do
  valid_from 
  valid_to   { Time.utc(2000) }
end

Credential.blueprint(:from_in_future) do
  valid_from { Time.utc(2050) }
  valid_to   
end





