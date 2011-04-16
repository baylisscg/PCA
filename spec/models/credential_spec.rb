# -*- coding: utf-8 -*-

require 'spec/spec_helper'

shared_examples_for "Credential" do

  context "allow creation with no dates" do
    subject { described_class.make_unsaved(Credential.plan(:no_time)) }
    it { should_not be_nil }
    it { should be_valid }
    its(:valid_from) { should be_nil }
    its(:valid_to) { should be_nil}
  end

  context "allow creation with no to" do
    subject { described_class.make_unsaved(Credential.plan(:from_only)) }
    it { should_not be_nil  }
    it { should_not be_valid }
    its(:valid_from) { should == Time.utc(2011) }
    its(:valid_to) { should be_nil }
  end    
  
  context "allow creation with no from" do    
    subject { described_class.make_unsaved(Credential.plan(:to_only)) }
    it { should_not be_nil }
    it { should_not be_valid }
    its(:valid_from) { should be_nil }
    its(:valid_to) { should == Time.utc(2012) }
   end
  
  context "allow creation" do
    let(:params) { Credential.plan }
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
    subject { described_class.make_unsaved(Credential.plan(:to_in_past)) } 
    it { should be_expired }
    it { should_not be_valid }
    its(:valid_to){ should be_less_than_time Time.now }
  end
  
  context "should be expired if valid from is in the future" do
    subject {described_class.make_unsaved(Credential.plan(:from_in_future)) } 
    its(:valid_from){ should be_greater_than_time Time.now }
    it {should be_expired}
    it { should_not be_valid }
  end
end

#
#
#
describe Credential do
  it_should_behave_like "Credential"
end

