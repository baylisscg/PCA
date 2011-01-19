# -*- coding: utf-8 -*-

require 'rspec'
require 'spec_helper'

describe Credential do
  
  it "allow creation" do
    x = Factory.build("cred_no_time")
    
    x.should_not be_nil
    x.should be_valid
    
    x.valid_from.should be_nil
    x.valid_to.should   be_nil
  end

  it "allow creation" do
    x = Factory.build("cred_from")
    
    x.should_not be_nil
    x.should_not be_valid
    
    x.valid_from.should == Time.new(2011)
    x.valid_to.should be_nil
  end    
  
  it "allow creation" do    
    x = Factory.build("cred_to")

    x.should_not be_nil
    x.should_not be_valid
    
    x.valid_to.should == Time.new(2012)
  end
  
  it "allow creation" do
    x = Factory.build("credential")
    
    x.should_not be_nil
    x.should be_valid
    
    x.valid_from.should == Time.new(2011)
    x.valid_to.should == Time.new(2012)
  end
  
end

#
#
#
shared_examples_for Credential do
  
  it "should " do    
    @cred.should_not be_nil
    @cred.should be_valid
    
    @cred.valid_from.should == @valid_from
    @cred.valid_to.should == @valid_to
  end
  
end

