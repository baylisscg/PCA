#
#
#
require "spec/spec_helper"

describe "Client API" do

  describe "Add event" do

    it "should reject empty calls" do
      post "/events"
      response.status.should == 404
    end

    it "should " do

      cred_params = Cert.plan 
      cred = Cert.make_unsaved(cred_params)
      cred.should_receive(:save)
      
      # Rails mangles everything to Strings so we have to adjust the 

      conn = mock()
      conn.should_receive(:save)

      cred_params[:valid_from] = cred_params[:valid_from].to_s
      cred_params[:valid_to]   = cred_params[:valid_to].to_s
      cred_params[:type] = "x509"

      Credential.should_receive(:find_or_initialize).with(cred_params).and_return(cred)

      Connection.should_receive(:find_or_create_by).and_return(conn)

      request = {
        :cred => cred_params,
        :connection => {:service => "",
          :connection => ""},
        :event => [],
      }
      post '/events', request
      response.status.should == 200
    end

  end

end
