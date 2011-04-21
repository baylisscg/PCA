#
#
#

require "spec/spec_helper"

describe "main index" do

  context "root page" do
    subject { visit root_path }
    it { should be_success }
    it_should_behave_like "an HTML5 page"
  end

end

describe "search page" do
  
  context "a basic request" do
    subject { visit search_path }
    it { should be_success }
    it_should_behave_like "an HTML5 page"
  end

end

describe "login page" do
  
  context "a basic request" do
    subject { visit login_path }
    it { should be_success }
    it_should_behave_like "an HTML5 page"
  end

end
