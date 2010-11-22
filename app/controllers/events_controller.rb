=begin
=end

#require 'bunny'

class EventsController < ApplicationController

  layout "html5.html"

  def find_cert
    return Cert.criteria.id( BSON::ObjectID.from_string(params[:cert_id])).first
  end

  def find_event
    return Event.criteria.id( BSON::ObjectID.from_string(params[:id])).first
  end
  
  skip_before_filter :verify_authenticity_token, :only => :create
  before_filter :verify_custom_authenticity_token, :only => :create

  
  def index
    @types = Connection.do_tag_count.find # Event.only(:action).aggregate
#    puts "Got #{@types} events"
    respond_to do |format|
      format.html { render :index }
      format.json { render :json }
      format.xml { render :xml => @events }
    end
  end
    
  def get_event
    @cert = find_cert
    @counts = @cert.events.all.count
    @types  = @cert.events.only(:action).aggregate
    
    respond_to do |format|
      format.html # index.html.erb 
      format.xml { render :xml => @events }
    end 
  end

  def events
    
  end

  #
  #
  #
  def create
    
    cert = Cert.find_or_add(params[:cert])

    connection = Connection.find_or_create_by(:server  => params[:service],
                                              :peer    => params[:connection], 
                                              :cred_id => cert.id, 
                                              :conn_id => params[:id])

    event = Event.create(:action => params[:event],
                         :created_at => Time.parse(params[:datestamp]))
    event.save
    connection.events << event
    connection.save

    redirect_to cert_path(event.id)

  end
    
  def show
#    id = BSON::ObjectID.from_string params[:id]
    @event = Event.where("_id"=>params[:id] ).first
    puts "Event = #{@event}"

    if @event then
      respond_to do |format|
        format.html { render :show }
        format.atom { render :show, :layout=>nil }
        format.xml { render :xml => @event }
      end
    end
  end

  def verify_custom_authenticity_token
    # checks whether the request comes from a trusted source
  end

  
end
