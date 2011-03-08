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


  #
  #
  #
  def create
    
    cred = if params[:cred].is_a? String then  
             Credential.criteria.id(BSON::ObjectID.from_string(params[:cred])).first
           elsif params[:cred].is_a? Hash then
             Credential.find_or_initialize(params[:cred].symbolize_keys)
           end

    raise ActionController::RoutingError.new('Not Found') unless cred
    
   
    conn = params[:connection].symbolize_keys
    conn[:cred_id] = cred.id

    connection = Connection.find_or_initialize_by(conn)

    if params[:event] then
      params[:event].each do |event|
        Event.create(:action => event[:type],
                     :created_at => Time.parse(event[:datestamp]))
#        event.save
        connection.events << event
      end
    end

    cred.save
    connection.save

    render :text => "Added"

#    redirect_to cert_path(event.id)

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
