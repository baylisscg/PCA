#
#
#

require "spec_helper"

#
# Successful HTLM
#
shared_examples_for "a valid HTML valid response" do

  its(:charset){ should == "utf-8" }
  its(:content_type){ should == "text/html"}

end
