#
#
#

require "spec_helper"

describe ConnectionsController do
  
  #
  describe "GET index" do

    subject { get "index" } 
    
    context "with no existing conenctions" do
      before do
        Connection.should_receive(:paginate).and_return []
      end
      it_should_behave_like "a HTTP GET to a multi-format resorce"
    end

    context "with existing connections" do
      #before do
      #  Connection.should_receive(:paginate).and_return 5.times.map {|n| Connection.make }
      #end
      it_should_behave_like "a HTTP GET to a multi-format resorce" do
        before do
          Connection.should_receive(:paginate).and_return 5.times.map {|n| Connection.make }
        end
      end
    end

  end

  #
  #
  # 
  describe "POST a new connection" do
    
    let!(:params) { Connection.plan }
    let!(:conn) { Connection.make(params) }

    context "when no identical connection exists" do

      before(:each) do
        Connection.should_receive(:new).with(params).and_return(conn)
        conn.should_receive(:save).and_return()
        conn.stub(:_id)
      end

      subject{ post :create, params }
      it { should be_redirect }
      its(:content_type){should eq(Mime::HTML) }
      its(:location){ should == connection_url(conn) } # Redirect to correct URL
      
    end
  end

  #
  #
  #
  #  it "should allow creating with JSON return" do
  #    create_setup
  #    @request.env["HTTP_ACCEPT"] = Mime::JSON
  #    post :create, @params
  #    response.should be_success
  #    response.content_type.should == Mime::JSON
  #  end
  
  #
  #
  #
  #   it "should allow creating with XML return" do
  #     create_setup
  #     @request.env["HTTP_ACCEPT"] = Mime::XML

  #     @conn.should_receive(:to_xml)
  
  #     post :create, @params
  #     response.should be_success
  #     response.content_type.should == Mime::XML
  # #    response.should render_template("create")
  #   end
  
  #
  #
  #
  # it "should not allow creating new connections without sufficient arguments" do
  
  #   post :create, {:peer=>"client.example.org"}
  
  #   response.status.should == 500
  #   response.charset.should == "utf-8"
  #   response.content_type.should == Mime::HTML
  #   response.should render_template("errors/500")

  # end
  
  describe "adding to a connection" do

    before(:each) do
      @params = Connection.plan
      @conn = mock_model(Connection,
                         @params)
    end
    
    #
    #
    #
    it "add cert" do
      
      attribs = Credential.plan    
      cert =  mock_model(Credential, attribs)

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
end
