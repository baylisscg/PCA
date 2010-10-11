require 'spec_helper'

describe ConnectionsController do

  before(:each) do
    @conn = mock_model(Connection,
                       :server=>"server.example.org",
                       :peer=>"client.example.org")
  end
  
  it "should render index" do

    get :index
    response.should be_success
    response.charset.should == "utf-8"
    response.content_type.should == "text/html"
    response.should render_template("index")

  end
  
   it "allow creating new connections" do

   # Connection.should_receive(:new).with(:server=>"server.example.org",
   #                                      :peer=>"client.example.org").and_return(@conn)
   # @conn.should_receive(:insert)

    Connection.should_receive(:create).with(:server=>"server.example.org",
                                            :peer=>"client.example.org").and_return(@conn)
    
    post :create, {:server=>"server.example.org",:peer=>"client.example.org"}
    
    response.content_type.should == "text/html"
    response.location.should == connection_url(@conn) # Redirect to correct URL

  end
  
  it "should not allow creating new connections without sufficient arguments" do
    
    post :create, {:peer=>"client.example.org"}
    
    response.status.should == 500
    response.charset.should == "utf-8"
    response.content_type.should == "text/html"
    response.should render_template("errors/500")

  end
  
end

describe  ConnectionsController, "adding to a connection" do

  before(:each) do 
    @conn = mock_model(Connection,
                       :server=>"server.example.org",
                       :peer=>"client.example.org")
    Connection.should_receive(:find).with(@conn.id).and_return(@conn)
  end
    
  it "add cert" do
    
    attribs = { :subject_dn=>"test db",
                :issuer_chain=>["test ca"],
                :valid_from=>Time.now.utc,
                :valid_to=>Time.now.utc,
                :cert_hash=>"f0ad7e27"}
    
    @cert =  mock_model(Cert, attribs)
    @cert.should_receive(:upcert)
    
    @conn.should_receive(:cred_id=).with(@cert.id)
    @conn.should_receive(:upcert)
    
    Cert.should_receive(:new).and_return(@cert)
    
    attribs[:id] = @conn.id # Add the id to the parameters
    
    post :add_cert, attribs
    
  end
end

describe ConnectionsController, "adding an event" do

  before(:each) do
    @conn = mock_model(Connection,
                       :server=>"server.example.org",
                       :peer=>"client.example.org")

    @event_attribs = {"action"=>"Test Action"}
    @event = mock_model(Event,
                        @event_attribs) #:action=>"Test Action")
  end
  
  it "bad cert id" do
    post( :add_event, :id=>"not an id", :post=>@attribs)
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

    post( :add_event, :id=> @conn.id, :post=>attribs)

    assert_response :found

    assigns(:conn).should == @conn
    assigns(:event).should == @event
    response.status.should == 302
 
  end
  
end

