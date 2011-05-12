# -*- coding: utf-8 -*-

require "spec_helper"

#
#
#
shared_examples_for "a basic Credential" do

 it_should_behave_like "a basic Entity"

  context "a credential with no user" do
  end

  context "a credential with no connections" do
 
  end

end

#
#
#
shared_examples_for "a TimedCredential" do

  it_should_behave_like "a basic Credential"

  context "allow creation with no dates" do
    subject { described_class.make_unsaved(TimedCredential.plan(:no_time)) }
    it { should_not be_nil }
    it { should be_valid }
    its(:valid_from) { should be_nil }
    its(:valid_to) { should be_nil}
  end

  context "allow creation with no to" do
    subject { described_class.make_unsaved(TimedCredential.plan(:from_only)) }
    it { should_not be_nil  }
    it { should_not be_valid }
    its(:valid_from) { should == Time.utc(2011) }
    its(:valid_to) { should be_nil }
  end    
  
  context "allow creation with no from" do    
    subject { described_class.make_unsaved(TimedCredential.plan(:to_only)) }
    it { should_not be_nil }
    it { should_not be_valid }
    its(:valid_from) { should be_nil }
    its(:valid_to) { should == Time.utc(2012) }
   end
  
  context "allow creation" do
    let(:params) { TimedCredential.plan }
    subject { described_class.make_unsaved(params) }
    it { should_not be_nil}
    it { should be_valid }
    its(:valid_from) { should be_equal_to_time params[:valid_from] }
    its(:valid_to){ should be_equal_to_time params[:valid_to] }
  end
  
  context "should stop being valid when valid_to is deleted" do    
    before{ subject.valid_to = nil }
    its(:valid_to){ should be_nil }
    it { should_not be_valid }
  end
 
  context "should be expired if valid to is in the past" do
    subject { described_class.make_unsaved(TimedCredential.plan(:to_in_past)) } 
    it { should be_expired }
    it { should_not be_valid }
    its(:valid_to){ should be_less_than_time Time.now }
  end
  
  context "should be expired if valid from is in the future" do
    subject {described_class.make_unsaved(TimedCredential.plan(:from_in_future)) } 
    its(:valid_from){ should be_greater_than_time Time.now }
    it {should be_expired}
    it { should_not be_valid }
  end
end

#
#
#
describe Credential do
  subject { Credential.make }
  it_should_behave_like "a basic Credential"
end

describe TimedCredential do
  subject { TimedCredential.make }
  it_should_behave_like "a TimedCredential"
end

