#
#
#

require 'spec_helper'

describe EventsController do

  #
  #
  #
  before(:each) do
    Factory.build(:root_cert)
    Factory.build(:signing_cert)
    Factory.build(:ee_cert)
  end

  #
  #
  #
  it "should render index" do

    tag_count = mock
    Connection.should_receive(:do_tag_count).and_return(tag_count)
    tag_count.should_receive(:find).and_return([["Test",1]])

    get :index
    response.should be_success
    response.charset.should == "utf-8"
    response.content_type.should == "text/html"

    response.should render_template("index")

  end

end
