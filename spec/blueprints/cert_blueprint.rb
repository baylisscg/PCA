

Sham.subject_dn(:unique=>false) {"cn=#{Faker::Name.first_name} #{Faker::Name.last_name},dc=example,dc=org"} 
Sham.cert_hash(:unique=>false)  {"deadbeeffeeddeed"}

Cert.blueprint(:root) do
  subject_dn {"cn=Root Cert,dc=example,dc=org"}
  cert_hash  {"0123456789abcdef"}
  issuer     { nil }
end

Cert.blueprint do
  
  subject_dn 
  cert_hash

end

