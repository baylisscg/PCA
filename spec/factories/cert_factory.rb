=begin
=end

#require 'spec_helper'

require 'factory_girl'

require 'openssl'
include OpenSSL::X509

base_dn = [["DC","org"], ["DC","example"],["O","Test CA"]]
root_dn = base_dn + [["CN","Root Cert"]]
signing_dn = base_dn +  [["CN","Signing Cert"]]
ee_dn = base_dn + [["O","Test"], ["CN","Test Cert"]]

#Factory.sequence :ee_dn do |dn|
#  base_dn = [["DC","org"], ["DC","example"],["O","Test CA"]]
#  root_dn = base_dn + ["CN","Root Cert"]
#  signing_dn = base_dn + ["CN","Signing Cert"]
#  base_dn.dup + [["O","Test"], ["CN","Test Cert"]]
#send

Factory.sequence :cert_hash do |hash|
"%06x" % rand(100000)
end

#
# Create a root cert
#
Factory.define :root_cert, :class => "Cert", :default_strategy => :build do |root|

  root.subject_dn Name.new(root_dn.to_a).to_s
#  root.issuer_dn Name.new(root_dn).to_s
 # root.issuer { |issuer| root._id  }
  root.valid_from Time.utc(2010)
  root.valid_to Time.utc(2011)
  root.cert_hash { Factory.next(:cert_hash)  }

  root.after_stub do |c|
    c.issuer = c
 #   c.sha = Cert.calc_sha(c)
  end
  root.after_build do |c|
    c.issuer = c
 #   c.sha = Cert.calc_sha(c)
  end
end

Factory.define :signing_cert, :class => "Cert", :default_strategy => :build do |cert|
  cert.subject_dn Name.new(signing_dn).to_s
#  cert.issuer_dn  Name.new(root_dn).to_s
  cert.valid_from Time.utc(2010)+1
  cert.valid_to Time.utc(2011)-1
  cert.cert_hash { Factory.next(:cert_hash) }
  cert.association :issuer, :factory => :root_cert
 # cert.signed_by { Cert.first(:conditions => { :subject_dn => cert.issuer_dn }) }

  cert.after_build do |c|
 #   c.sha = Cert.calc_sha(c)
  end
end

#
# Just enough defined to be valid.
#
Factory.define :ee_min_cert, :class => "Cert", :default_strategy => :build do |cert|
  cert.subject_dn Name.new(ee_dn).to_s
#  cert.issuer_dn  Name.new(signing_dn).to_s
  cert.cert_hash  { Factory.next(:cert_hash) }
#  cert.association :signers, :factory => :signing_cert
#  cert.after_build do |c|
#    c.sha = Cert.calc_sha(c)
#  end
#  cert.after_stub do |c|
#    puts "Stubbing"
#    c.sha = Cert.calc_sha(c)
#  end
end

#
# Adds valid from / to
#
Factory.define :ee_cert, :class => "Cert", :parent => "ee_min_cert" do |cert|
  cert.valid_from Time.utc(2010)+2
  cert.valid_to Time.utc(2011)-2
end

Factory.define :test_cert, :class => "Cert", :parent => "ee_min_cert" do |cert|
  cert.association :issuer, :factory => :signing_cert
end

