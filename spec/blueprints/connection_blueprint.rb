

Sham.server(:unique=>false) { "https://service.example.org" }
Sham.peer(:unique=>false) {"http://#{Faker::Internet::domain_name}:#{1024+rand(4096)}" }

Connection.blueprint do

  server
  peer

end
