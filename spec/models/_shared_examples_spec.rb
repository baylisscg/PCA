#
#
#

puts __FILE__
Dir["spec/models/**/*_shared.rb"].each {|f| puts f; require f}

