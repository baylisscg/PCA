require 'rubygems'
require 'rspec'
require 'spec_helper'

#describe Dn do
        
#  it "should allow creation" do
#    subject = "dc=org,dc=example,cn=test"
#    x = Dn.new(:subject_dn=>subject)
#    x.should be_valid
#  end

#  it "should not allow creation of invalid DNs" do
#       
#    x = Dn.new
#    x.should_not be_valid
#    
#    x.subject_dn = "dc=org,dc=example,fail=test"
#    x.should_not be_valid
   
#    x.subject_dn = "dc=org,dc=example,PZ=!test"
#    x.should_not be_valid
#  end

#  it "Should properly convert DNs to URNs" do
#    
#    urn_org_example_test = URI::parse("urn:dn:dc=org,dc=example,cn=test")
#    dn_org_example_test = "dc=org,dc=example,cn=test"
#    urn_org_example_testca_testuser = URI::parse("urn:dn:dc=org,dc=example,ou=test+ca,cn=test+user")
#    dn_org_example_testca_testuser = "dc=org,dc=example,ou=test CA,cn=Test User"
#     
#    Dn.to_urn(dn_org_example_test).should == urn_org_example_test
#    Dn.to_urn(dn_org_example_test.upcase).should == urn_org_example_test
#    Dn.to_urn(dn_org_example_testca_testuser).should == urn_org_example_testca_testuser

#  end

#end
