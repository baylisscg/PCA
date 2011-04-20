# -*- coding: utf-8 -*-

require 'rubygems'
require 'rspec'
require 'spec_helper'

describe Cert do
  
  before(:all) do
    @args = Cert.plan
    @subject = @args[:subject_dn] #"dc=org,dc=example,cn=test"
    @issuer = @args[:issuer] #"dc=org,dc=example,ou=ca"
    @hash = @args[:cert_hash] #"DEADBEEF"
  end
  
  before(:each) do
    @cert = CertFactory.make(@args)
  end
  
  it "should allow creation" do
    
    @cert.subject_dn.should == @subject
    @cert.issuer.should     == @issuer
    @cert.cert_hash.should  == @hash
    @cert.should be_valid
    
  end
end

describe Cert do
  


  it_should_behave_like "a TimedCredential" do
    subject { Cert.make }
  end

  before(:all) do
    @args = Cert.plan
    @subject = @args[:subject_dn] #"dc=org,dc=example,cn=test"
    @issuer = @args[:issuer] #"dc=org,dc=example,ou=ca"
    @hash = @args[:cert_hash] #"DEADBEEF"
    @valid_from = @args[:valid_from]
    @valid_to   = @args[:valid_to]
    @cred = Cert.make_unsaved(@args)
  end

  it "should have equality" do    
    # Should equal itself
    @cred.should == @cred
  end
  
end

