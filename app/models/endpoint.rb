=begin
=end

require 'bson'

class Endpoint
  include Mongoid::Document

  field "url" # The URL to push to 

end
