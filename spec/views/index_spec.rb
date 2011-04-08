#
#
#

require 'spec_helper'

describe "application/index.html.erb" do

  before(:all) do
    @connections = 10.times.map{ |n| make_connection }
    @page = 1
    @pages = 1
  end

  it "should render without error when no events are passed." do
    assign(:connections,[])
    assign(:page,@page)
    assign(:pages,1)
    render :template => "application/index.html.erb", :layout => "layouts/html5.html.erb"
    rendered.should be_html5
  end

  
  it "should render without error when an event is passed." do
    assign(:connections,@connections[0..0])
    assign(:page,@page)
    assign(:pages,1)
    render :template => "application/index.html.erb", :layout => "layouts/html5.html.erb"
    rendered.should be_html5
  end

  it "should render without error when several event are passed." do
    assign(:connections,@connections)
    assign(:page,@page)
    assign(:pages,@pages)
    render :template => "application/index.html.erb", :layout => "layouts/html5.html.erb"
    rendered.should be_html5
  end  

end

