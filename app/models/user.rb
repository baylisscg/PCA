=begin
=end

require 'bson'

class Connection
  include Mongoid::Document

  field "name"

  # Can have many update endpoints
  embeds_many "update_endponts", :class_name => "Endpoint"

  references_many "connections", :class_name => "Connection"

  embeds_many "credentials", :class_name => "Credential"

end
