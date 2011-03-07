#
#
#

require 'httpclient'

module PCA

  #
  #
  #
  class Client < HTTPClient
    
    def iniatalize(args)
      super
      @target = "http://localhost:3000/target" || args[-1][:target] 
    end

    #
    #
    #
    def send_event(event)
      self.post(@target,{ 
                  'Content-Type' => 'application/json; charset=UTF-8', 
                  :content=> event.to_json })
    end

  end

end
