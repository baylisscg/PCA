require 'spec_helper'

describe ConnectionsController do
  
  def create_setup
    Connection.should_receive(:new).with(@params).and_return(@conn)
    @conn.should_receive(:save).with().and_return()
  end

  before(:each) do
    @params = {:server => "server.example.org",
               :peer   => "client.example.org"}
    @conn = mock_model(Connection,
                       @params)
  end
  
  #
  #
  #
  it "should render index" do

    get "index"
    response.should be_success
    response.charset.should == "utf-8"
    response.content_type.should == Mime::HTML

    response.should render_template("index")

  end

  #
  #
  #
  it "should allow creating new connections" do
    create_setup

    post :create, @params

    response.should be_redirect
    response.content_type.should == Mime::HTML
    response.location.should == connection_url(@conn) # Redirect to correct URL
  end

  #
  #
  #
  it "should allow creating with JSON return" do
    create_setup
    @request.env["HTTP_ACCEPT"] = Mime::JSON
    post :create, @params
    response.should be_success
    response.content_type.should == Mime::JSON
  end
  
  #
  #
  #
  it "should allow creating with XML return" do
    create_setup
    @request.env["HTTP_ACCEPT"] = Mime::XML

    @conn.should_receive(:to_xml)

    post :create, @params
    response.should be_success
    response.content_type.should == Mime::XML
#    response.should render_template("create")
  end

  #
  #
  #
  it "should not allow creating new connections without sufficient arguments" do
    
    post :create, {:peer=>"client.example.org"}
    
    response.status.should == 500
    response.charset.should == "utf-8"
    response.content_type.should == Mime::HTML
    response.should render_template("errors/500")

  end
  
end

#
#
#
describe  ConnectionsController, "adding to a connection" do

  before(:each) do
    @params = {:server=>"server.example.org",
      :peer=>"client.example.org"}
    @conn = mock_model(Connection,
                       @params)
  end
 
  #
  #
  #
  it "add cert" do
    
    attribs = { :subject_dn=>"test db",
                :issuer_chain=>["test ca"],
                :valid_from=>Time.now.utc,
                :valid_to=>Time.now.utc,
                :cert_hash=>"f0ad7e27"}
    
    cert =  mock_model(Cert, attribs)
    cert.should_receive(:upcert)
    
    @conn.should_receive(:cred_id=).with(cert.id)
    @conn.should_receive(:upcert)
    
    Cert.should_receive(:new).and_return(cert)
    Connection.should_receive(:find).with(@conn.id).and_return(@conn)

    attribs[:id] = @conn.id # Add the id to the parameters
    
    post :add_cert, attribs
    
    response.should be_redirect
    response.location.should == connection_url(@conn) # Redirect to correct URL
    response.charset.should == "utf-8"
    response.content_type.should == Mime::HTML

  end


  describe ConnectionsController, "adding an event" do

    before(:each) do
      #     @conn = mock_model(Connection,
      #                        :server=>"server.example.org",
      #                        :peer=>"client.example.org")
      #     
      @event_attribs = {"action"=>"Test Action"}
      @event = mock_model(Event,
                          @event_attribs)
    end
  
    #
    #
    #
    it "should not allow adding an event with a bad connection id" do
      post :add_event, :id=>"not an id", :post=>@attribs
      response.should_not be_success
      response.charset.should == "utf-8"
      response.content_type.should == Mime::HTML
    end
    
    it "add a valid event" do
      
      attribs = {"action"=>"Test Action"}
      
      events = mock
      @conn.should_receive(:events).and_return(events)
      events.should_receive(:<<).with(@event)
      @conn.should_receive(:upcert)

      Connection.should_receive(:find).with(@conn.id).and_return(@conn)
      Event.should_receive(:new).with(@event_attribs).and_return(@event)
      
      @conn.id

      post :add_event, :id=> @conn.id, :post=>attribs

      assert_response :found
      
      assigns(:conn).should == @conn
      assigns(:event).should == @event
      response.status.should == 302
      
    end
  end
end

