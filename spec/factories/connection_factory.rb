
Factory.define :event do |event|
  event.action "Action"
end

Factory.sequence :service_url do |client|
  service_url = [ "service.example.org:443" ] # ... etc (I'm using a real subset of first names)
  service_url[(rand * service_url.length)]
end

Factory.sequence :client_url do |client|
  "client_#{rand(100)}.example.org:#{1001+rand(50000)}"
end

#
#
#
Factory.define :connection, :class => "Connection" do |conn|

  conn.server  Factory.next(:service_url)
  conn.peer    Factory.next(:client_url)
#  conn.cert
#  conn.events { (10.times.map{ |n| Factory.build(:event) }).to_a }

end

Factory.define :test_connection, :class => "Connection" do |conn|
  conn.server  "http://service.example.org"
  conn.peer    "http://client.example.org"
  conn.updated_at Time.now
  conn.association :cert, :factory => :test_cert
  conn.events  { |event| [event.association(:event)] }
  
end
