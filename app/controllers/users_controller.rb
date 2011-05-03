#
#
#

class UsersController < ApplicationController

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

  #
  # handle omniauth callbacks
  #
  def auth
    auth = request.env["omniauth.auth"]
    user = User.find_via_omniauth(auth)
  end
  
end
