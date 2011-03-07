#
#
#
require "spec/spec_helper"

describe "Client API" do

  describe "Add event" do

    it "should " do
      request = {
        :cred => { :type => :x509,
                   :subject => "",
                   :key_hash => ""},
        :connection => {:service => "",
          :connection => ""}
        :event => [ {} ] 
      }
      post '/events'
    end

  end

end
