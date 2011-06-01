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
    
    let!(:params) { x = Connection.plan; x.delete(:credential); x }
    let!(:conn) { Connection.make(params) }

    subject{ post :create, params }

    context "when no identical connection exists" do
      context "when passed a valid connection" do
      before(:each) do
         Connection.should_receive(:new).with(params).and_return(conn)
         conn.should_receive(:save).and_return()
        end

        it { should be_redirect }
        its(:content_type){should eq(Mime::HTML) }
        its(:location){ should == connection_url(conn) } # Redirect to correct URL
      end

      context "when passed an invalid connection" do
        # Redefine params and conn 
        let!(:params) { x = Connection.plan; x.delete :server; x}
        let!(:conn) { Connection.make(params) }

        before(:each) do
          Connection.should_receive(:new).with(params).and_return(conn)
          conn.should_receive(:save).and_return()
          #conn.stub(:_id)
        end

        it { should be_redirect }
        its(:content_type){should eq(Mime::HTML) }
        its(:location){ should == connection_url(conn) } # Redirect to correct URL
        
      end
    end
    
  end

  
  describe "Add events to a connection" do

    let!(:event_params) { Event.plan }
    let!(:event) { Event.make_unsaved event_params }
    let!(:conn_params) { x = Connection.plan; x }
    let!(:conn)  { Connection.make_unsaved conn_params  }
    let(:params) do
      {:event => event_params,
        :id => conn._id.to_s}
    end

    subject { post(:add_event, params) } 

    before(:each) do
      Event.should_receive(:new).with(event_params).and_return(event)
      Connection.stub_chain(:criteria,:for_ids,:first).and_return(conn)

      temp = double()
      conn.should_receive(:events).and_return(temp)
      temp.should_receive(:<<).with(event)
      conn.should_receive(:save)
    end


    #
    #
    #
    context "add event" do
      it { should be_redirect }
      its(:location){ should == connections_url } #(conn._id) }
    end
  end

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

      cert.should_receive(:save)
      
      @conn.should_receive(:cred_id=).with(cert.id)
      @conn.should_receive(:save)
      
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
        post :add_event, :id=>"not an id", :post=>@attribs, :event=>{}
        response.should_not be_success
        response.charset.should == "utf-8"
        response.content_type.should == Mime::HTML
      end
      
      it "add a valid event" do
        
        attribs = Event.plan #{action=>"Test Action"}
        
        events = mock
        @conn.should_receive(:events).and_return(events)
        events.should_receive(:<<).with(@event)
        @conn.should_receive(:save)

        Connection.should_receive(:find).with(@conn.id).and_return(@conn)
        Event.should_receive(:new).with(attribs).and_return(@event)
        
        @conn.id

        post :add_event, {:id=> @conn.id, :event=>attribs}

        assert_response :found
        
        assigns(:conn).should == @conn
        assigns(:event).should == @event
        response.status.should == 302
        
      end
    end
  end
end
