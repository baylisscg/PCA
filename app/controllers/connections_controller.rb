=begin
=end

require "bson"

class ConnectionsController < ActionController::Base

  protect_from_forgery

  layout "html5.html"

  rescue_from BSON::InvalidObjectId, :with =>:invalid_conn_id

  #
  #
  #
  def index

    page = {:page => 1 || params[:page].to_i,
            :per_page => 200}

    threshold = get_int(:max) if params[:max]

    sort = get_sort

    # Build the query
    query = Connection.criteria
    query = query.event_within(threshold) if threshold
    query = query.order_by(get_sort) if sort

    @conns = if page then query.paginate(page) else query.all end

    x = @conns.first
#    puts "#{x} -> \"#{x.cert}\" -> \"#{Cert.where(:connection_ids=>x._id).first}\" "

    respond_to do |format|
     format.html # index.html.erb
      format.atom { render( :layout => nil) }
      format.json { render :json => @events }
      format.xml  { render :xml => @events }
    end
  end

  #
  #
  #
  def show

#    id =  BSON::ObjectID.from_string params[:id]
    @conn = Connection.find(params[:id])
#    @conn = Connection.criteria.id(id).first

    respond_to do |format|
      format.html # index.html.erb
      format.atom { render( :layout => nil) }
      format.json { render( :layout => nil) }
    end
  end

  #
  #
  #
  def create

    server = params[:server]
    peer = params[:peer]

    @connection = Connection.new({:server=>server,:peer=>peer})

    Rails.logger.info {"@connection = #{@connection.id}"}

    if @connection.valid? then

      Rails.logger.info { "Creating new connection #{@connection.id}" }

      @connection.save

      respond_to do |format|
        format.html { redirect_to @connection }
        format.atom { render( :layout => nil) }
        format.json { render :json => @connection, :layout => nil }
        format.xml  { render :xml => @connection,
                             :layout => nil,
                             :template=>"connections/show" }
      end
    else
      render "errors/500.html", :layout=>"html5.html", :status=> 500
    end
  end

  #
  #
  #
  def add_cert

    @conn = Connection.find(params[:id])

    elements = [:subject_dn, :issuer_chain,:valid_from,:valid_to]

    # if we don't have all the parameters we need raise an error
    elements.each do  |elem|
      if !params.has_key?(elem) then
        render "/500.html", :status=> 500
        return
      end
    end

    cert_param = {}
    elements.each do |elem|
      cert_param[elem] = params[elem]
    end

    cert = Cert.new(cert_param)

    if cert.valid? then

      # save the cred and update the connection
      cert.upcert
      @conn.cred_id = cert.id
      @conn.upcert

      respond_to do |format|
        format.html { redirect_to @conn }
        format.json { render :json => cert }
        format.xml  { render :xml => cert }
      end
    else render "/500.html", :status=> 500 end

  end

  #
  #
  #
  def add_event

    @event = Event.new(params[:post])

    @conn = Connection.find(params[:id])
    @conn.events << @event
    @conn.upcert

    respond_to do |format|
      format.html { redirect_to @conn }
      format.json { render :json => result }
      format.xml  { render :xml => result }
    end
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
