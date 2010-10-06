=begin
=end

class ConnectionsController < ActionController::Base
  
  protect_from_forgery

  layout "html5.html"
  
  #
  #
  #
  def index
#    return nil
    page = {:page=>get_int(:page), :per_page=>10} if params[:page]
    
    threshold = get_int(:max) if params[:max]

    sort = get_sort
    
    # Build the query
    query = Connection.criteria
    query.only(:server, :peer, :conn_id, :created_at, :updated_at, :cred_id)
    
    query = query.event_within(threshold) if threshold
    query = query.order_by(get_sort) if sort
        
    @events = if page then query.paginate(page) else query.all end
    @conns = @events

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
    id =  BSON::ObjectID.from_string params[:id]
    @conn = Connection.criteria.id(id).first

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


    @cert = Connection.create({:server=>server,:peer=>peer})
    
    if @cert.valid? then
    
      result = {"connection_id"=>certs_path(@cert)}
    
      respond_to do |format|
        format.html { redirect_to @cert }
        format.atom { render( :layout => nil) }
        format.json { render :json => result }
        format.xml  { render :xml => result }
      end
    else
      render "/500.html", :status=> 500
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

    @conn = Connection.find(params[:id])
    @event = Event.new(params[:action])

    @conn.events << @event
    
    @event.save
    @conn.upcert
    
#    respond_to do |format|
#      format.html { redirect_to @conn }
#      format.json { render :json => result }
#      format.xml  { render :xml => result }
#    end
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
  
end
