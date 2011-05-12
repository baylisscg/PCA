#
#
#

require "spec_helper"

shared_examples_for "a valid HTTP response" do
  it { should be_success }
  its(:charset){ should == "utf-8" }
end

shared_examples_for "a HTTP GET to a multi-format resorce" do 

  context "when rendering as HTML" do
    it_should_behave_like "a valid HTTP response"
    its(:content_type) { should eq(Mime::HTML) }
#    it { should render_with_layout("html5") }
  end

  context "when rendering as ATOM" do
    before { @request.env["HTTP_ACCEPT"] = Mime::ATOM}
    it_should_behave_like "a valid HTTP response"
    its(:content_type) { should eq(Mime::ATOM) }
  end

  context "when rendering as JSON" do
    before { @request.env["HTTP_ACCEPT"] = Mime::JSON }
    it_should_behave_like "a valid HTTP response"
     its(:content_type) { should eq(Mime::JSON) }
  end

end
