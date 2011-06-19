=begin

=end

#require 'nokogiri'

class CertsController < ApplicationController


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

    id = params[:id]   
    @cert = Cert.criteria.for_ids(id).first()
    @conns = Connection.uses_cert(@cert)

    respond_to do |format|
      format.html 
      format.atom { render( :layout => nil) }
    end
  end
  
end
