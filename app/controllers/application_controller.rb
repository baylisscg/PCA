#
#
#
#


#
#
#
class ApplicationController < ActionController::Base

  around_filter :audit_helper

  protect_from_forgery

#  layout "html5.html"
  
  private
  
  #
  #
  #
  def audit_helper
    Rails.logger.info "\nUser attempting #{controller_name}:#{action_name}\n"
    begin
      yield
    rescue => exception
      Rails.logger.error "Caught exception! #{exception}\n#{controller_name}:#{action_name} failed."
      raise
    end
    Rails.logger.info "#{controller_name}:#{action_name} successful"
  end



end
