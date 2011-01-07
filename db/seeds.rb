# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#



require "factory_girl"
require "faker"
require "openssl"
require "pca"

include OpenSSL::X509
include PCA

Factory.find_definitions

users = 10 || ENV["users"].to_i
min_jobs = 10 || ENV["jobs-min"].to_i
max_jobs = 100 || ENV["jobs-max"].to_i

root_cert = Factory.build(:root_cert)
root_cert.issuer = root_cert
root_cert.save
signing_cert = Factory.create(:signing_cert,:issuer=>root_cert)

user_dns = users.times.map do |n|
  org = [[["O","Org 1"]],[["O","Org 2"]],[["O","Org 3"],["OU","Unit 1"]]].rand
  base = [["DC","org"],["DC","example"]]
  Name.new(base+org+[["CN",Faker::Name.first_name+" "+Faker::Name.last_name]]).to_s
end

user_certs = user_dns.map do |dn|
  Factory.create(:ee_cert,
  :subject_dn=>dn,
#  "issuer_dn"  => signing_cert.subject_dn,
  "issuer" => signing_cert)
end

generator = EventGenerator.new

user_certs.each do |cert|

  hits = min_jobs + rand(max_jobs)

  hits.times do |n|
    conn = Factory.build(:connection, :cert => cert)
    #conn.cert = cert
    #cert.connections << conn
    #cert.save
    parent = nil
    events = []
    generator.each do |name|
      events << Factory.build(:event,:action=>name,:parent=>parent)
      parent = events[-1].id 
    end
   # puts events.join("->")
    conn.events = events #[Factory.build(:event)
    conn.save
    generator.reset
  end
end

