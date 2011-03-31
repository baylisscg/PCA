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

class Service < Entity
  Object_Type = "http://activitystrea.ms/schema/1.0/service"
end


module PCA
  module Objects
    class GRAM < Service
       Object_Type = "http://pca.nesc.gla.ac.uk/schema/service/gram"
    end
   class GSI < Service
       Object_Type = "http://pca.nesc.gla.ac.uk/schema/service/gsi"
    end
   class WMS < Service
       Object_Type = "http://pca.nesc.gla.ac.uk/schema/service/wms"
    end
  end
end
