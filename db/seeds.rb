# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

#require 'app/models/event'
#require 'app/models/cert'

require 'openssl'

include OpenSSL::X509

limit=10

server = "dames.nesc.gla.ac.uk:443"
clients = (1..1).map { "client.nesc.gla.ac.uk:3566" }

base_dn = [["DC","org"], ["DC","example"],["O","Test CA"]]

root_ca_dn = base_dn.dup << ["CN","Root Cert"]
signing_dn =  base_dn.dup << ["CN","Signing Cert"]

dn_1 = Cert.find_or_create_by( :subject_dn => Name.new(root_ca_dn).to_s,
                               :issuer_dn => Name.new(root_ca_dn).to_s,
                               :issuer_chain => [],
                               :valid_from => Time.utc(2010),
                               :valid_to => Time.utc(2011),
                               :cert_hash => "dc53fa41" )

Rails.logger.info "Root DN = #{dn_1}"

dn_2 = Cert.find_or_create_by( :subject_dn =>  Name.new(signing_dn).to_s,
                               :issuer_dn =>  Name.new(root_ca_dn).to_s,
                               :valid_from => Time.utc(2010)+1,
                               :valid_to => Time.utc(2011)-1,
                               :issuer_chain => [ dn_1.sha ],
                               :cert_hash => "dc53fa42" )

Rails.logger.info "Signing DN = #{dn_2}"

ee_cert_dn = [["DC","org"], ["DC","example"],["O","Test CA"],["CN","Test User"]]

ee = Cert.find_or_create_by( :subject_dn =>  Name.new(ee_cert_dn).to_s,
                             :issuer_dn =>  Name.new(signing_dn).to_s,
                             :valid_from => Time.utc(2010)+1,
                             :valid_to => Time.utc(2011)-1,
                             :issuer_chain => [ dn_2.sha, dn_1.sha ],
                             :cert_hash => "dc53fa42" )

Rails.logger.info "Entity certificate #{ee}"

# Create a group of proxy certs
certs = (1..10).map do |proxy|
  args = {}
  args[:subject_dn] = Name.new(ee_cert_dn.dup << ["CN","#{proxy}#{Time.now.utc.usec}"]).to_s
  args[:issuer_dn] =  Name.new(ee_cert_dn).to_s
  args[:valid_from] = Time.now.utc
  args[:valid_to] = (Time.now+3600*96).utc
  args[:issuer_chain] = [ ee.sha, dn_2.sha, dn_1.sha ]
  args[:cert_hash] = "dc53fa41#{proxy}"
  Cert.find_or_create_by(args)
end

def do_events
  
  x = [Event.new(:action => "GSI Connect")]
  x = (1 .. (1+rand(10))).map { |m| Event.new(:action=>"R job #{m} submitted") } 
  x <<  Event.new(:action => "GSI Disconnect")
  #x
end

certs.flatten.each do |cert|
  (1..(1+limit)).each do |n|
    x = Connection.new do |conn|
      conn.server = server
      conn.peer = clients[rand(limit)]
      conn.cred = cert._id
      conn.events = do_events # (1 .. (1+rand(10))).map { |m| Event.new(:action=>"R job submitted") }
    end
    x.save
  end
end
