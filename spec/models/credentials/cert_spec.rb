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
    @cert = Factory(:root_cert,:subject_dn=>@subject)
  end
  
  it "should allow creation" do
    
    @cert.subject_dn.should == @subject
    @cert.should be_valid
    
  end
end

describe Cert do
  
  it_should_behave_like "Credential"
  
  before(:each) do
    @cred = Factory.build(:root_cert)
    @valid_from = Time.new(2010)
    @valid_to   = Time.new(2011)
  end
  
  # it "should know whether it is valid" do
  #
  #   now =  Time.at(Time.now.to_i)
  #   forward_5_seconds = now + 5
  #
  #   # No validity set so expired
  #   @cert.expired?.should be_true
  #
  #   @cert.valid_from = now
  #   @cert.valid_to =  forward_5_seconds
  #   # Cert is currently valid
  #   @cert.expired?.should be_false
  #
  #   # Set certificate to be valid but expired
  #   @cert.valid_from = now - 10
  #   @cert.valid_to = now - 5
  #   @cert.should be_valid
  #   @cert.expired?.should be_true
  #
  #   # Incorrect ordering
  #   @cert.valid_from = now + 5
  #   @cert.valid_to = now - 10
  #   @cert.should_not be_valid
  #   @cert.expired?.should be_true
  #
  # end
  
  it "should have equality" do
    
    # Should equal itself
    @cred.should == @cred
    
  end
  
end

