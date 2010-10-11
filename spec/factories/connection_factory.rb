
#Factory.sequence :client do |n|
#  num = 1+n%10
#  "client#{num}.example.org:#{1001+rand(50000)}"
#end

Factory.define :event do |event|
  event.action "Action"
end

Factory.define :basic_connection, :class => "Connection" do |conn|

  conn.server "service.example.org:443"
  
  conn.sequence(:peer) { |n| "client_#{rand(100)}.example.org:#{1001+rand(50000)}" }
  
  conn.events { (10.times.map{ |n| Factory.build(:event) }).to_a }

end
