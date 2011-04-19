#

require 'spec_helper'


shared_examples_for "a basic Event" do

  it_should_behave_like "a basic Entity"
  it { should be_valid }  
  it { should respond_to(:created_at) }
  it { should respond_to(:action) }
  its(:action){ should be_kind String }

end

describe Event do
 
  it "should allow creation" do

    event = Event.new
    event.should_not be_valid
    
    event.action = "Test"
    event.action.should == "Test"
    event.created_at = nil # Wipe default time
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

  it_should_behave_like "a basic Event" do
    subject { Event.make }
  end

end



