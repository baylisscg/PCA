#
#
#

require 'uri'
require 'cgi'
require 'digest/sha1'
require 'openssl'

=begin

=end
module Dn
   
  def check_subject_dn
    errors.add(:subject_dn,"Subject DN must be a recognisable DN") unless subject_dn =~ /^(?>(?>\/|,{0,1})[A-Za-z]{1,2}[=:][\w @]+)+$/
  end

  #
  # Converts DN (RFC2253) to a URN with URI encoding.
  # dc=org,dc=example,ou=test,cn=Test User => urn:dn:dc=org:dc=example:ou=test:cn=test+user
  #
  def Dn.to_urn(dn)
    URI::parse("urn:dn:" << dn.split(",").map { |x| x.split("=") } .map { |y| y[0] << "=" << CGI::escape(y[1]) } .join(",").downcase)
  end
  
end

class Cert
  include Mongoid::Document
  #include Mongoid::Timestamps  
  include Dn
  
  field :subject_dn
  field :issuer_dn
  field :issuer_chain, :type => Array
  field :valid_from, :type => Time
  field :valid_to, :type => Time
  field :cert_hash
  field :sha
  field :signature
  field :proxy, :type=>Boolean

  index :sha, :background => true
  index :subject_dn, :background => true
  index :issuer_dn, :background => true
  index :issuer_chain, :background => true
  index :signature, :background => true
 
  key :sha
  validates_uniqueness_of :_id 
  

  set_callback(:save, :before) do |cert|
    puts "Before SAVE"
    cert.update_sha
  end
  
  set_callback(:create, :before) do |cert|
     puts "Before CREATE"
    cert.update_sha
  end

 set_callback(:update, :before) do |cert|
    puts "Before UPDATE"
    cert.update_sha
  end

  validate :time_valid
  validates_presence_of  :subject_dn, :issuer_dn, :cert_hash
  
  #
  #
  #
  def to_s
    out = "Cert = "
    out <<         "subject: " << self.subject_dn
    out << "\n" << "issuer: " << self.issuer_dn
    out << "\n" << "issuer: " << self.issuer_chain.join(", ") if self.issuer_chain.length > 0
    out << "\n" << "hash: " << self.cert_hash
    out << "\n" << "SHA: " << self.sha if self.sha
    return out 
  end
  
  #
  # Time is valid if either both valid_from and valid_to are nil or
  # both are set and valid_from is before valid_to.
  #
  def time_valid
    if self.valid_from and self.valid_to then
      errors.add(:valid_from,
                 " must be before the valid to date.") unless self.valid_from <= self.valid_to
    else
      if self.valid_from or self.valid_to then
        errors.add(:valid_from,
                   " must be set when valid_to is set.") unless self.valid_from
        errors.add(:valid_to,
                   " must be set when valid_from is set.") unless self.valid_to
      end
    end
  end

  #
  # 
  #
  def expired?    
    now = DateTime.now
    return true unless self.valid_from && self.valid_from <= now 
    return true unless self.valid_to && now <= self.valid_to
    return false
  end

  def issuer_cert
    Cert.criteria.where(:subject_dn=>self.issuer).all
  end
  
  def proxy?
    self.is_proxy
  end

  def proxies
    Cert.critera.and(:subject_dn => /self.subject_dn/,
                     :is_proxy => true)
  end

  #
  # Overridden
  #
  def ==(other)
    return false unless other.is_a?(Cert)
    x  =  self.subject_dn == other.subject_dn
    x &&= self.issuer_chain  == other.issuer_chain
    x &&= self.cert_hash  == other.cert_hash
  end

  named_scope :subject_is, lambda { |subject| where( :subject_dn => subject ) }
#  named_scope :issuer_chain_is, lambda { |subject| where( :subject_dn =>  Regexp.new( params[


  def self.find_or_add(cert)
    
    crt = if cert.is_a? Array then
            OpenSSL::X509::Certificate.new(cert[0])
          else
            OpenSSL::X509::Certificate.new(cert)
          end
      
    subject = crt.subject.to_s

    issuer_chain = if cert.is_a? Array then 
                     cert[1..-1].map { |chain| OpenSSL::X509::Certificate.new(chain).subject.to_s }
                   else
                     [crt.issuer.to_s]
                   end

    valid_from = crt.not_before
    valid_to   = crt.not_after
    hash = crt.hash.to_s

    asn_crt = OpenSSL::ASN1.decode(crt)
    signature = asn_crt.value[2].value.unpack('H*')[0]

    sha = Cert.create_sha(subject, issuer_chain)

    Cert.find_or_create_by({ :subject_dn => subject,
                             :issuer_chain => issuer_chain,
                             :cert_hash => hash,
                             :valid_from => valid_from,
                             :valid_to => valid_to,
                             :signature => signature,
                             :sha => sha})
  end

  def issued_by
    Cert.find(self.issuer_chain[0])
  end

  #
  #
  #
  scope :issued, lambda { |cert|
    where( "issuer_chain.0" => cert.sha )
  }

  protected

  def self.create_sha(subject_dn,issuer_dns)
    hash = Digest::SHA256.new
    hash << subject_dn
    issuer_dns.each { |dn| hash << dn }
    return hash.hexdigest
  end

  def duplicate?
    dupes = Cert.where.and(:subject_dn=>self.subject_dn,
                           :issuer_chain=>self.issuer_chain,
                           :cert_hash=>self.cert_hash
                           )
    return dupes
  end
 
  def dn_hierarchy_hook 
    self.subject_dn.split(",")
  end

  #
  # Hash is the SHA256 hash of
  # Subject DN, Issuer DN, Chain DNs, valid from, valid to 
  # in hex
  #
  def update_sha
    hash = Digest::SHA256.new
    hash << self.subject_dn
    self.issuer_chain.each { |dn| hash << dn } unless self.issuer_chain.empty?
    hash << self.valid_from.iso8601
    hash << self.valid_to.iso8601
    self.sha = hash.hexdigest
  end
  
end

