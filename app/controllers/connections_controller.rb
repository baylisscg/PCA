=begin
=end

require "bson"
require "pp"

class ConnectionsController < ApplicationController

  rescue_from BSON::InvalidObjectId, :with =>:invalid_conn_id

  respond_to :html, :json, :xml, :atom

  #
  #
  def index
    @page = 1 || params[:page].to_i
    respond_with( @conns= Connection.order_by(get_sort).page(@page) )
  end

  #
  #
  #
  def show    
    id = BSON::ObjectId.from_string(params["id"])
    @conn = Connection.criteria.for_ids(id).first
    respond_with @conn, :location=>connection_url(@conn)
  end

  #
  #
  #
  def create
    conn_params = {}
    conn_params[:server] = params[:server] if params[:server] 
    conn_params[:peer]   = params[:peer]   if params[:peer]
    conn_params[:credential] = params[:credential] if params[:credential] 
    conn = Connection.create(conn_params)
    respond_with conn
  end

  #
  #
  #
  def add_cred
    # Find the ID of the connection 
    @conn = Connection.criteria.for_ids(BSON::ObjectId.from_string(params["id"])).first
    
    #Create or find credential
    cred_params = params["credential"]
    @cred = case cred_params["type"]
            when "X509"
              # Pass the X.509 cert
              Cert.from_cert cred_params
            else
              # Whatever is in the credential
              Credential.find_or_create cred_params
            end
    @conn.credential = @cred
    @cred.save
    @conn.save
    respond_with @cred
  end

  #
  #
  #
  def add_event

    raise "No event passed params = #{params}" unless params[:event]
    id = BSON::ObjectId.from_string(params["id"])
    @event = Event.new(params[:event].symbolize_keys)

    @conn = Connection.criteria.for_ids([id]).first
    raise BSON::InvalidObjectId unless @conn
    # @event.connection = @conn
    @conn.events << @event
    @conn.save
    @event.save
    respond_with @event
  end

  def events
    @conn = Connection.find(params[:id])
    respond_to do |format|
      format.html { redirect_to @conn }
      format.json { render :json => result }
      format.xml  { render :xml => result }
    end
  end

  protected

  #
  #
  #
  def get_int(param, default=0)
    min = 0
    max = 100000
    begin
      n = Integer(params[param])
      puts max
      if (min <= n) && (n <= max) then
        puts "Return #{n}"
        n
      else
        puts "Default"
        default
      end
    rescue
      puts "Help"
      default
    end
  end

  #
  #
  #
  def get_sort

    base = [:updated_at]

    if params[:sort]
      sort = params[:sort]
      if sort == "asc"
        base << :asc
      elsif sort == "desc"
        base << :desc
      else
        base << :desc
      end
    else
      base << :desc
    end

    return base

  end


  def invalid_conn_id
    Rails.logger.warn "Bad connection id #{params[:id]} from #{request.remote_ip}"
    @error = "#{params[:id]} is an invalid connection ID"
    respond_to do |format|
      format.html { render "/errors/400.html", :status => 400 }
      format.atom { render( :layout => nil) }
      format.json { render( :layout => nil) }
    end
  end

end
