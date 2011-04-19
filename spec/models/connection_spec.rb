# -*- coding: utf-8 -*-

require 'rubygems'
require 'rspec'
require 'spec_helper'

describe Connection do
  
  it "when all required parameters are set" do
    conn = Connection.new
    conn.should_not be_valid
    conn.server = "server.example.org"
    conn.should_not be_valid
    conn.peer = "client.example.org"
    conn.should be_valid
  end
  
  context "when only #server is set" do
    subject { Connection.new }
    let(:server) {  "server.example.org" }
    before(:all) {subject.server = server }
    it { should_not be_valid }
    its(:server) { should == server }
    its(:peer) { should be_nil }
  end

  context "when only #peer is set" do
    subject { Connection.new }
    let(:peer) {  "peer.example.org" }
    before(:all) {subject.peer = peer }
    it { should_not be_valid }
    its(:server) { should be_nil }
    its(:peer) { should == peer }
  end

  it "should allow one step create" do
    conn = Connection.new(Connection.plan)
    conn.should be_valid
  end
  
  
  
end
