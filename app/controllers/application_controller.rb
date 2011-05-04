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

  layout "html5.html"
  
  private
  
  #
  #
  #
  def audit_helper
    puts "Called Filter user attempting #{controller_name}:#{action_name}"
    begin
      yield
    rescue => exception
      puts "Caught exception! #{exception} attempted #{controller_name}:#{action_name} failed."
      raise
    end
    puts  "#{controller_name}:#{action_name} successful"
  end

end
