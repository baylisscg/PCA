#
#
# Specs for the 
#
require "spec/spec_helper"

# Subject will be a ActionDispatch::TestResponse
shared_examples_for "an HTML5 page" do
  its(:content_type) { should == "text/html" }
  its(:body) { should be_html5 }
end

shared_examples_for "an ATOM page" do
  its(:content_type) { should == "application/atom+xml" }
end


