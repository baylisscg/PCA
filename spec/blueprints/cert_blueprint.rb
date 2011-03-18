#
#
#

Sham.subject_dn(:unique=>false) {"cn=#{Faker::Name.first_name} #{Faker::Name.last_name},dc=example,dc=org"} 
Sham.cert_hash(:unique=>false)  { "deadbeeffeeddeed" }

Cert.blueprint do
  subject_dn
  cert_hash
end

class CertFactory
  
  def self.make_root
     x = Cert.make( :subject_dn => "cn=Root Cert,dc=example,dc=org",
                   :cert_hash  => "0123456789abcdef" )
    x.issuer = x._id
    return x
  end

  @@root = CertFactory.make_root

  def self.make(args)
    x = Cert.make(args)
    x.issuer = @@root._id
    return x
  end

end

