# encoding: utf-8
#
#

require 'bson'

class User < Person

  Object_Type = "http://pca.nesc.gla.ac.uk/schema/objects/user"
  
  has_many :credentials, :class_name => "Credential", :inverse_of => :user

end
