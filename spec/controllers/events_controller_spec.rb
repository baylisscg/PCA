require 'spec_helper'

describe EventsController do

  it "should render index" do

    count = mock
    Event.should_receive(:all).and_return(count)
    count.should_receive(:count).and_return(1)

    get :index
    response.should be_success
    response.charset.should == "utf-8"
    response.content_type.should == "text/html"

    response.should render_template("index")

  end

end
