# -*- coding: utf-8 -*-

require 'spec_helper'

describe Cert, "multiple certs" do

  before(:all) do

    @subject = "dc=org,dc=example,cn=test"
    @issuer = "dc=org,dc=example,ou=ca"
    @hash = "DEADBEEF"
    @valid_from = Time.now-60
    @valid_to   = Time.now+60

    @root = Cert.new(:subject_dn=> @subject,
    :issuer_dn => @subject,
    :cert_hash => @hash,
    :valid_from => @valid_from,
    :valid_to => @valid_to)

    # because we'll be using searches we must save the cert.
    #    @root.issuer_chain << @root._id
    @root.save
  end

  after(:all) do
    @root.delete
  end

  # it "self signed certificates should works" do
  #   @root.issuer_chain.should_not be_nil
  #   @root..should == [@root._id]
  #   Cert.issued(@root).first.should == @root
  #   @root.issued_by.should == @root
  #   #    @root.signed.should == [@root._id]
  #   @root.self_signed?.should == true
  # end

  #  it "should allow child certificates" do
  #  child = Cert.new(:subject_dn => @subject,
  #  :issuer_dn  => @subject,
  #  :cert_hash  => @hash,
  #  :valid_from => @valid_from,
  #  :valid_to   => @valid_to,
  #  :issuer_chain => [@root._id])
  #end
  
  
end