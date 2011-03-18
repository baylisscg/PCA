#
#
#
require "spec/spec_helper"

describe "Client API" do

  #
  #
  #
  describe "Invalid calls" do
    #
    #
    #
    it "should reject empty calls" do
      Credential.should_not_receive(:criteria)
      Credential.should_not_receive(:find_or_initialize)
      post "/events"
      response.status.should == 404
    end

  end

  describe "Add event" do

    before(:each) do
      @cred_params = Cert.plan 
      @cred = Cert.make_unsaved(@cred_params)

      @conn_params = Connection.plan
      @conn = Connection.make_unsaved(@conn_params)

      @cred.should_receive(:save)
      @conn.should_receive(:save)

      @cred_params[:valid_from] = @cred_params[:valid_from].to_s
      @cred_params[:valid_to]   = @cred_params[:valid_to].to_s
      @cred_params[:type] = "x509"

      Credential.should_receive(:find_or_initialize).with(@cred_params).and_return(@cred)
      Credential.should_not_receive(:criteria)
      Connection.should_receive(:find_or_initialize_by).and_return(@conn)

      @request = {
        :cred => @cred_params,
        :connection => @conn_params,
      }

    end


    #
    #
    #
    it "should accept connections with no events." do
      @request[:event] = []
      post '/events', @request
      response.status.should == 200
    end

    #
    #
    #
    it "should accept connections with a single event." do
      @request[:event] = Event.plan
      post '/events', @request
      response.status.should == 200
    end
   
    #
    # 
    #
    it "should accept calls with multiple events." do
      @request[:event] = 10.times.map { |n| Event.plan }
      post '/events', @request
      response.status.should == 200
    end

  end
  
end

