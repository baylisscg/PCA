#
#
#
require "spec/spec_helper"

describe "Client API" do

  describe "Add event" do

    before(:each) do
      @cred_params = Cert.plan 
      @cred = Cert.make_unsaved(@cred_params)

      @conn_params = Connection.plan
      @conn = Cert.make_unsaved(@conn_params)

    end

    it "should reject empty calls" do
      post "/events"
      response.status.should == 404
    end

    it "should " do

      @cred.should_receive(:save)
      @conn.should_receive(:save)

      @cred_params[:valid_from] = @cred_params[:valid_from].to_s
      @cred_params[:valid_to]   = @cred_params[:valid_to].to_s
      @cred_params[:type] = "x509"

      Credential.should_receive(:find_or_initialize).with(@cred_params).and_return(@cred)

      Connection.should_receive(:find_or_initialize_by).and_return(@conn)

      request = {
        :cred => @cred_params,
        :connection => @conn_params,
        :event => [],
      }
      post '/events', request
      response.status.should == 200
    end
   
  #
  #
  #
  it "should " do
    
    @cred.should_receive(:save)
    @conn.should_receive(:save)
    
    @cred_params[:valid_from] = @cred_params[:valid_from].to_s
    @cred_params[:valid_to]   = @cred_params[:valid_to].to_s
    @cred_params[:type] = "x509"
    
    Credential.should_receive(:find_or_initialize).with(@cred_params).and_return(@cred)
    
    Connection.should_receive(:find_or_initialize_by).and_return(@conn)
    
    request = {:cred => @cred_params,
               :connection => @conn_params,
               :event => 10.times.map { |n| Event.plan }
               }

    post '/events', request
    response.status.should == 200
  end

  end
  
end

