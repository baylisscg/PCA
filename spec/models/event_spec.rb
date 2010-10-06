
require 'rubygems'
require 'rspec'
require 'spec_helper'

describe Event do
 
  before(:each) do
    @event = Event.new(:action=>"test")
  end
  
  it "should allow creation" do

    event = Event.new
    
    event.should_not be_valid
    
    event.action = "Test"
    event.action.should == "Test"
    event.should be_valid
    
    #event.save
    
  end
  
  it "should allow one call creates" do
    
    event = Event.new(:action => "test")
    event.should be_valid
  end
  
  it "should have timestamps" do
    @event.should respond_to(:created_at)
    @event.should respond_to(:updated_at)
  end
   
end

