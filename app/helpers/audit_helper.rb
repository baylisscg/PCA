#
#
#
#

module AuditHelper

  class AuditFilter
    
    #
    #
    #
    def self.filter(controller)
      # Do stuff

      # Locate user

      begin
        yield
      rescue => exception
        logger.debug "Caught exception! #{exception}"
        raise
      end

      #Tidy up

    end

  end

end
