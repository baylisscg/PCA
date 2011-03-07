#
#
#

require "openssl"

include "OpenSSL"
include "OpenSSL::X509"

module PCA::Cert

    DEFAULT_LIFETIME = 60 ** 2 * 24 # 1 day
    
    #
    #
    #
    def make_root_cert(args)
      
      subject = Name.parse("/dc=org,/dc=example/cn=Root Cert") || args[:subject]
      
    end

    def make_cert(args)
      
      required_args = [:type, :name, :ttl, :issuer, :serial, :publickey]
      required_args.each { |param|
        raise ArgumentError, "make_cert called without #{param}" unless args.include?(param)       
      }

      cert = Certificate.new
      cert.subject = args[:name]
      cert.not_before = Time.now
      cert.not_after = Time.now + Cert::DEFAULT_LIFETIME
    
      cert.issuer = args[:issuer].subject
      cert.public_key = args[:publickey]

    end

    #
    #
    #
    def make_proxy(args)
      
      extension_factory = ExtensionFactory.new

    end 
    
  end

  

end


