# 

#
#
#

require 'factory_girl'

Factory.define "credential" do |cred|
  
  cred.valid_from Time.utc(2011)
  cred.valid_to Time.utc(2012)
  
end

Factory.define "cred_no_time", :class => "Credential" do |cred|
  
end

Factory.define "cred_from", :class => "Credential" do |cred|
  
  cred.valid_from Time.utc(2011)

end

Factory.define "cred_to",  :class => "Credential" do |cred|
  
  cred.valid_to Time.utc(2012)
  
end