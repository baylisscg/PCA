# -*- coding: utf-8 -*-

require 'rubygems'
require 'rspec'
require 'spec_helper'

describe "connection routes" do
  
  it "basic routes" do
    
    { :get => "/connections"}.should route_to(:controller=>"connections",
                                              :action=>"index")
    { :get => "/connections/an_id"}.should route_to(:controller=>"connections",
                                                   :action=>"show",
                                                   :id => "an_id")
  end
  
end
