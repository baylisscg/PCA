
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
    event.should_not be_valid
    
    time = DateTime.now
    event.created_at = time
    Rails.logger.info "#{time.class} #{event.created_at.class}"
#    event.created_at.should == time 
    event.should be_valid
  end
  
  it "should allow one call creation" do
    time = DateTime.now
    event = Event.new(:action => "test",:created_at=>time)
    event.should be_valid
  end
 
  it "should have timestamps" do
    @event.should respond_to(:created_at)
#    @event.should respond_to(:updated_at)
  end
   
end

