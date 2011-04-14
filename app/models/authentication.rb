#
#
#
#

class Authentication
  include Mongoid::Document

  field :provider, :type => String
  field :uid, :type => String

  embedded_in :user, :class_name => "User", :inverse_of => :authentication_mechanisms

end
