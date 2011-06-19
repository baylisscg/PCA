#
#
#

require "bson"

class CredentialsController < ApplicationController


  caches_action :index, :show

  respond_to :html, :atom

  def index
    respond_with( @creds = Credential.all() )
  end
     
  #
  #
  #
  def show
    id = BSON::ObjectId.from_string(params["id"])
    respond_with( @cred = Credential.criteria.for_ids(id).first() )
  end

  def events
    id = BSON::ObjectId.from_string(params["id"])
    @cred = Credential.criteria.for_ids(id).first()
    puts @cred.last_event_at
    respond_with @cred
  end
  
end
