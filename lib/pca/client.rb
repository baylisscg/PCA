#
#
#

require 'uri'
require 'psych'
require 'net/http'
require 'pp'
require 'openssl'
require 'base64'

module PCA

  #
  #
  #
  class Client < Net::HTTP
    
    BASE_HEADERS = { 'Content-Type' => "application/json", 'Accept' => "application/json"}

    # You must use newobj instead of new to initialise this class.
    def initialize(args={})
      PP.pp args
      @url = URI.parse ( args["url"] || "http://localhost:3000/connections" )
      @conn = args["connection"]
      @events = args["events"] || []
      @credential = { :type=> args["credential"]["type"],
        :cert => Base64.encode64( args["credential"]["cert"]),
        :issuer => args["credential"]["issuer"].map {|issuer| Base64.encode64( issuer) }
      }
      super @url.host, @url.port
    end

    def run

      result = self.send_connection
      data = Psych.parse(result.body).to_ruby
      PP.pp data
      @url.path=  URI.parse(result.header["location"]).path

      cred_result = self.send_cred
      self.pp_result cred_result 

      return unless cred_result.kind_of? Net::HTTPCreated
      self.send_events
      
      self.pp_result self.request_get(@url.path,BASE_HEADERS)
    end

    def pp_result(result)
      puts "Status = #{result.code}"
      PP.pp result.to_hash
      begin
        PP.pp( Psych.parse(result.body).to_ruby)
      rescue Psych::SyntaxError
        PP.pp result.body
      end
    end

    #
    def send_connection(conn=@conn)
      self.request_post(@url.path, Psych.to_json( conn ),  BASE_HEADERS)
    end

    def send_cred(cred=@credential)
      payload =  Psych.to_json :credential=> cred 
      self.request_post(@url.path+"/add_cred", payload,  BASE_HEADERS)
    end

    def extract_id(tag)
      tag.split('/')[-1]
    end

    def send_events(events=@events)
      events.inject(nil) do |parent,event|

        event[:parent] = parent if parent
        result = self.send_event event
        
        self.pp_result result

        data = Psych.parse(result.body).to_ruby

        break unless result.kind_of? Net::HTTPCreated

        # POST succeded so extract parent ID and post next event 
        extract_id(data["tag"]) if data["tag"]
      end
    end

    def send_event(event)
      self.request_post(@url.path+"/add_event", Psych.to_json( :event=>event ),  BASE_HEADERS)
    end

  end

end

if __FILE__ == $PROGRAM_NAME
  puts "Starting"
  client = PCA::Client.newobj Psych.parse_file("./client.yml").to_ruby
  client.run
end
