# encoding: utf-8
#
#
#

require 'bson'

#
# The Crednetial class models the basic credential
# with a validity period. Specific crednetial 
# implementations extend this class.
#
class Credential < Entity

  Object_Type = "http://pca.nesc.gla.ac.uk/schema/object/credential"
 
  belongs_to :user,        :class_name => "User",     :inverse_of=> :credentials
  has_many   :connections, :class_name => "Connection", :inverse_of=> :credential
 
  #
  #
  #
  def self.find_or_initialize(args)
    {"x509" => Cert }[args["type"]].find_or_initialize_by(args)
  end
  
end

