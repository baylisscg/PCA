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
shared_examples_for "Credential" do
  
  it "should be valid when both dates are set" do    
    @cred.should_not be_nil
    @cred.should be_valid
    
    @cred.valid_from.should == @valid_from
    @cred.valid_to.should == @valid_to
  end
  
  it "should stop being valid when valid_from is deleted" do    
    @cred.valid_from = nil
    @cred.should_not be_valid
    @cred.valid_from = @valid_from
    @cred.should be_valid
  end
  
 it "should stop being valid when valid_to is deleted" do    
    @cred.valid_to = nil
    @cred.should_not be_valid
    @cred.valid_to = @valid_to
    @cred.should be_valid
  end
  
  it "should be expired if valid to is in the past" do
    
    now = Time.at(Time.now.to_i)
    in_the_past = now - 10 # 10 seconds ago
    
    @cred.valid_to = in_the_past 
    @cred.should be_expired
      
    
  end
  
  it "should be expired if valid from is in the future" do
    
    now = Time.at(Time.now.to_i)
    in_the_future = now + 10 # 10 seconds from now
    
    @cred.valid_from = in_the_future
    @cred.should be_expired

  end
  
  
end

describe Credential do
  
  it_should_behave_like "Credential"
  
  before(:each) do
    @cred = Factory.build("credential")
    @valid_from = Time.new(2011)
    @valid_to   = Time.new(2012)
  end
  
end

