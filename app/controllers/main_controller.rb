#
#
#
#


#
#
#
class MainController < ApplicationController 

  #
  #
  #
  def index

    @page = 1 || params[:page]
    @connections = Connection.order_by([:updated_at,:desc]).paginate({ :page=>@page, :per_page=>10 })
    @pages = Connection.count 
    
    respond_to do |format|
      format.html # index.html.erb 
      format.xml 
    end

  end

  #
  #
  #
  def search
    if request.post?
      @query = params[:q]
      @results = Cert.criteria.where(:subject_dn=> Regexp.new(params[:q]) ).all()
      respond_to do |format|
        format.html { render :action=>"results" }
      format.xml 
    end
    else
      respond_to do |format|
      format.html # search.html.erb
      format.xml 
    end
    end
  end

  #
  #
  #
  def find
    
    if !params[:cred] && !params[:conn] && !params[:event] then
      raise Error.new("No parameters")
    end
    
    certs = Cert.subject_is(Regexp.new(params[:cred][:subject])).only(:id) if params[:cred]
    
    # event params
    if params[:event] then
      action = Regexp.new(params[:action]) if params[:action]
    end
    
    before  = params[:conn][:before]
    after   = params[:conn][:after]

    query = Connection.criteria
    query.merge Connection.within(:before=>before,:after=>after)
    query.where(:peer=>Regexp.new(params[:conn][:peer])) if params[:conn][:peer]
   
    if certs
      x = certs.map { |x| x.id }
      temp = { :cred_id=>{ "$in" => x } }
      query.where(temp)
    end
    #    query.where(:created_at => {"$gt"=>after, "$lt"=>before}).and(:peer=>/localhost/)

    puts "Hits =  #{query.count}"
    
    @hits = query
  end
  
end
