# -*- coding: utf-8 -*-

require 'rubygems'
require 'rspec'
require 'spec_helper'

describe "connection routes" do
  
  it "basic routes" do
    
    { :get => "/connections"}.should route_to(:controller=>"connections",
                                              :action=>"index")
    
  end
  
end
