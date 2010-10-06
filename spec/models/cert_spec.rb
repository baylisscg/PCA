# -*- coding: utf-8 -*-

require 'rubygems'
require 'rspec'
require 'spec_helper'

describe Cert do
  
  before(:all) do 
    @subject = "dc=org,dc=example,cn=test"
    @issuer = ["dc=org,dc=example,ou=ca"]
    @hash = "DEADBEEF"
  end

  before(:each) do
    @cert = Cert.find_or_initialize_by(:subject_dn=>@subject,
                                       :issuer_chain=>@issuer,
                                       :cert_hash=>@hash)
  end

  it "should allow creation" do
 
    @cert.subject_dn.should == @subject
    @cert.issuer_chain.should == @issuer
    @cert.cert_hash.should == @hash
    
#    @cert._id.class.should == BSON::ObjectID
    @cert.should be_valid
  
  end

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
    
    # Correct 
    @cert.valid_from = now - 5
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
    @cert.should == @cert

    other_cert = Cert.find_or_initialize_by(:subject_dn=>@subject,
                                            :issuer_chain=>@issuer,
                                            :cert_hash=>@hash)
    @cert.should == other_cert

    other_cert.subject_dn = @subject + "neql"
    @cert.should_not == other_cert

  end

  it "should not allow duplication" do 
    @cert.save
    new_cert = Cert.find_or_initialize_by(:subject_dn=>@subject,
                                          :issuer_chain=>@issuer,
                                          :cert_hash=>@hash)

    new_cert.should == @cert

    new_cert._id.should_not be_nil

    @cert._id.should == new_cert._id
    @cert.delete
    new_cert.should be_valid
  end
  
end

