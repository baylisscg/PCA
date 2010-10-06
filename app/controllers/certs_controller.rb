=begin

=end

#require 'nokogiri'

class CertsController < ApplicationController

  layout "html5"

#  respond_to :html, :only => :index
 # respond_to :xhtml, :html, :xml, :json, :atom
  
  caches_action :index, :show

  def index
    @certs = Cert.all()

    Rails.logger.warn "Formats = #{request.format}"

    respond_to do |format|
      format.xhtml 
      format.html 
      format.atom { render( :layout => nil) }
    end
  end
     
  #
  #
  #
  def show

    Rails.logger.warn "Formats = #{request.format} ( #{request.accepts.join(', ')}) #{ request.accepts[1].class}"
#   Rails.logger.warn "Formats = #{request.headers["HTTP_ACCEPT"]}"

    id = params[:id]   
    @cert = Cert.criteria.id(id).first()
    @conns = Connection.uses_cert(@cert.id)

    respond_to do |format|
#      format.xhtml 
      format.html 
      format.atom { render( :layout => nil) }
    end
  end
  
end
