=begin
=end

class EventsController < ApplicationController

  layout "html5.html"

  respond_to :html, :json

  def find_cert
    return Cert.criteria.id( BSON::ObjectID.from_string(params[:cert_id])).first
  end

  def find_event
    return Event.criteria.id( BSON::ObjectID.from_string(params[:id])).first
  end
  
  skip_before_filter :verify_authenticity_token, :only => :create
  before_filter :verify_custom_authenticity_token, :only => :create

  
  def index
    @types = Event.only(:action).aggregate
    respond_with @types
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

    def add_event(conn,event)
      action = event[:action]
      created = Time.parse(event[:datestamp])
      conn.events << Event.new(:action => action,
                               :created_at => created )
    end

    if params[:event] then
      if params[:event].is_a? Array then
        params[:event].each { |e| add_event(connection,e) }
      else
        add_event(connection, params[:event])
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
