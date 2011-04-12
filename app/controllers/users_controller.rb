#
#
#

class UsersController < ActionController::Base
  protect_from_forgery

  layout "html5.html"

  #
  #
  #
  def index
    @users = User.all
  end
  
  #
  #
  #
  def show
    @user = User.criteria.for_ids(params[:id]).first
  end
  
end
