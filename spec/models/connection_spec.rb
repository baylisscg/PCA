# -*- coding: utf-8 -*-

require 'rubygems'
require 'rspec'
require 'spec_helper'

describe Connection do
  
  it "should only become valid when all required parameters are set" do
    conn = Connection.new
    conn.should_not be_valid
    conn.server = "server.example.org"
    conn.should_not be_valid
    conn.peer = "client.example.org"
    conn.should be_valid
  end
  
  it "should allow one step create" do
    conn = Connection.new(:server=>"server.example.org", :peer=>"client.example.org")
  end
  
  
  
end
