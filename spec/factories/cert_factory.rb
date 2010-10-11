=begin
=end

#require 'spec_helper'

require 'factory_girl'

require 'openssl'
include OpenSSL::X509

base_dn = [["DC","org"], ["DC","example"],["O","Test CA"]]
root_dn = base_dn.dup << ["CN","Root Cert"]
signing_dn = base_dn.dup << ["CN","Signing Cert"]
ee_dn = base_dn.dup + [["O","Test"], ["CN","Test Cert"]]

Factory.define :root_cert, :class => "Cert" do |root| 
  root.subject_dn Name.new(root_dn).to_s
  root.issuer_dn Name.new(root_dn).to_s
  root.issuer_chain []
  root.valid_from Time.utc(2010)
  root.valid_to Time.utc(2011)
  root.cert_hash "dc53fa41"
end

Factory.define :signing_cert, :class => "Cert" do |cert|
  cert.subject_dn Name.new(signing_dn).to_s
  cert.issuer_dn  Name.new(signing_dn).to_s
  cert.issuer_chain []
  cert.valid_from Time.utc(2010)+1
  cert.valid_to Time.utc(2011)-1
  cert.cert_hash "dc53fa42"
end

#
# Just enough defined to be valid.
#
Factory.define :ee_min_cert, :class => "Cert" do |cert|
  cert.subject_dn Name.new(ee_dn).to_s
  cert.issuer_dn  Name.new(signing_dn).to_s
  cert.issuer_chain []
  cert.cert_hash "dc53fa43"
  cert.after_build {  |c| c.sha = Cert.calc_sha(c) }
end

#
# Adds valid from / to 
#
Factory.define :ee_cert, :class => "Cert", :parent => "ee_min_cert" do |cert|
  cert.valid_from Time.utc(2010)+2
  cert.valid_to Time.utc(2011)-2
end


