# -*- coding: utf-8 -*-

require 'rubygems'
require 'rspec'
require 'spec_helper'

describe Cert do

  before(:all) do
    @subject = "dc=org,dc=example,cn=test"
    @issuer = "dc=org,dc=example,ou=ca"
    @hash = "DEADBEEF"
  end

  before(:each) do
    @cert = Cert.new(:subject_dn=>@subject,
                     :issuer_dn=>@issuer,
                     :issuer_chain=>[@issuer],
                     :cert_hash=>@hash)
  end

  it "should allow creation" do

    @subject = "dc=org,dc=example,cn=test"
    @issuer = "dc=org,dc=example,ou=ca"
    @hash = "DEADBEEF"

    @cert.subject_dn.should == @subject
    @cert.issuer_dn.should == @issuer
    @cert.cert_hash.should == @hash

#    @cert._id.class.should == BSON::ObjectID
    @cert.should be_valid

    @cert.sha.should_not be_nil

  end
end

describe Cert do

  before(:each) do
    @cert = Factory.build(:ee_min_cert)
  end

#  after(:) do
#    @cert.destroy
#  end

  it "sould not allow bad validities" do

    now =  Time.at(Time.now.to_i)
    forward_5_seconds = now + 5

    @cert.should be_valid
    @cert.valid_to = now

    @cert.valid_to.tv_sec.should == now.tv_sec
    @cert.valid_to.usec.should == 0 # Mongoid strips µ seconds from timestamps

    @cert.valid_to.should == now

    @cert.should_not be_valid

    @cert.valid_from = forward_5_seconds
    @cert.valid_from.should == forward_5_seconds
    @cert.should_not be_valid

    # Correct times to 60s separation.
    @cert.valid_from = now - 50
    @cert.valid_to = now + 10

    @cert.should be_valid

    # Correct but expired
    @cert.valid_from = now - 5
    @cert.valid_to = now - 4
    @cert.should be_valid

  end

  it "should know whether it is valid" do

    now =  Time.at(Time.now.to_i)
    forward_5_seconds = now + 5

    # No validity set so expired
    @cert.expired?.should be_true

    @cert.valid_from = now
    @cert.valid_to =  forward_5_seconds
    # Cert is currently valid
    @cert.expired?.should be_false

    # Set certificate to be valid but expired
    @cert.valid_from = now - 10
    @cert.valid_to = now - 5
    @cert.should be_valid
    @cert.expired?.should be_true

    # Incorrect ordering
    @cert.valid_from = now + 5
    @cert.valid_to = now - 10
    @cert.should_not be_valid
    @cert.expired?.should be_true

  end

  it "should have equality" do

    # Should equal itself
    @cert.should == @cert

    other_cert = Factory.build(:ee_min_cert) #Cert.find_or_initialize_by(:subject_dn=>@subject,
                  #                           :issuer_dn=>@issuer,
                  #                           :cert_hash=>@hash)


    other_cert.subject_dn.should_not be_nil

    #Should equal clone of self
    @cert.should == other_cert

    # Should not equal modified clone
    other_cert.subject_dn = @cert.subject_dn + "neql"
    @cert.should_not == other_cert

  end

  it "should hash properly" do

    @cert.sha.should_not be_nil

    require "digest/sha1"
    @cert.sha.should_not == Digest::SHA256.new

    old_sha =  @cert.sha

    @cert.subject_dn = @cert.subject_dn + "more stuff"
    @cert.valid?
    @cert.sha.should_not == old_sha

  end

  it "should not allow duplication" do

    new_cert = Factory.build(:ee_min_cert, :cert_hash=>@cert.cert_hash)

    # Trigger sha calculation
    new_cert.valid?
    @cert.valid?

    new_cert.should == @cert

    @cert.sha.should == new_cert.sha

    new_cert.valid?
    @cert.valid?

    @cert.to_s.should == new_cert.to_s

    @cert.sha.should == new_cert.sha

    @cert.delete
  end

end

