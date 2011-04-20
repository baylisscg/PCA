#
#
#

Sham.valid_from(:unique=>false) { Time.now - ( 60**2*24*(365 - rand(364))) }
Sham.valid_to(:unique=>false)   { Time.now + ( 60**2*24*(365 - rand(364))) }

TimedCredential.blueprint do
  valid_from
  valid_to
end

TimedCredential.blueprint(:no_time) do
  valid_from { nil }
  valid_to   { nil }
end

TimedCredential.blueprint(:from_only) do
  valid_from { Time.utc(2011) }
  valid_to   { nil }
end

TimedCredential.blueprint(:to_only) do
  valid_from { nil }
  valid_to   { Time.utc(2012) }
end

TimedCredential.blueprint(:to_in_past) do
  valid_from 
  valid_to   { Time.utc(2000) }
end

TimedCredential.blueprint(:from_in_future) do
  valid_from { Time.utc(2050) }
  valid_to   
end





