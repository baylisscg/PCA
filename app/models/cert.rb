# encoding: utf-8
#

require 'uri'
require 'cgi'
require 'digest/sha1'
require 'openssl'
require 'base64'
require 'pp'

#
# Extends credential to support X509 public keys.
#
class Cert < TimedCredential

  
  Object_Type = "http://pca.nesc.gla.ac.uk/schema/object/x509"

  field :subject_dn, :index => true, :background => true, :unique=>true
  field :cert_hash,   :index=>true # The hash of the certificate
  field :proxy,      :type=>Boolean, :default=>false # True if a RFC proxy
  field :key 
  
  referenced_in   :issuer, :class_name => "Cert", :inverse_of=> :signed
  references_many :signed, :class_name => "Cert", :inverse_of=> :issuer, :foreign_key => :issuer_id, :validate => false # Only automatically validate  up the hierarchy to avoid infinite loops 

  index :issuer
 
  validates_presence_of :subject_dn, :message=>"You must supply a Subject DN"
  validates_presence_of :cert_hash, :message=>"You must supply a certificate hash."

  def as_json(options={})
    hash = super(options)
    hash[:subject_dn] = self.subject_dn
    hash[:cert_hash] = self.cert_hash if self.cert_hash
    hash[:issuer] = self.issuer._id if self.issuer
    hash[:key]    = self.key
    return hash
  end
  
  def self.recursive(x,xs)
    
    x509 = OpenSSL::X509::Certificate.new(Base64.decode64(x))
    attribs = {:subject_dn=> x509.subject.to_s}
    attribs[:valid_from] = x509.not_before 
    attribs[:valid_to] = x509.not_after    
    attribs[:key] = Base64.encode64 x509.public_key.to_der
    attribs[:cert_hash] = "SHA256:" << Digest::SHA256.hexdigest(x509.public_key.to_der)

    # Process other certs
    y,*ys = xs unless xs.empty?
    Cert.recursive(y,ys)._id if y

    cert =  Cert.find_or_create_by(attribs)
    
    #Set up issuers
    if x509.issuer == x509.subject then
      puts "\n\nSelf Signed\n\n"
      cert.issuer = cert
    elsif
      cert.issuer = Cert.where(:subject_dn=>x509.issuer.to_s).first
    end
    cert.save
    return cert
  end

  def self.from_cert(args)
    Cert.recursive args["cert"],args["issuer"]
  end

  #
  #
  #
  def to_s
    out = "subject: #{self.subject_dn}"
    out << "\n" << "issuer: " << self.issuer.subject_dn if self.issuer
#    out << "\n" << "issuer_chain: " << self.issuer_chain.map {|cert| cert.subject_dn }.join(", ") if self.issuer_chain
    out << "\nhash: #{self.cert_hash}\n"
    return out
  end

  #
  #
  #
  def issuer_cert
    Cert.criteria.id(self.issuer).all
  end

  #
  #
  #
  def proxy?
    self.is_proxy
  end

  #
  #
  #
  def proxies
    Cert.critera.and(:subject_dn => /self.subject_dn/,
                     :is_proxy => true)
  end

  named_scope :subject_is, lambda { |subject| where( :subject_dn => subject ) }
  #named_scope :issued, lambda { |cert| where(:issuer => cert._id)}
  
  #
  #
  #
  def self.issued(cert) 
    cert.signed
  end

  #
  #
  #
  def self.find_or_add(cert)

    crt = if cert.is_a? Array then
            OpenSSL::X509::Certificate.new(cert[0])
          else
            OpenSSL::X509::Certificate.new(cert)
          end

    subject = crt.subject.to_s

    signers = if cert.is_a? Array then
                     cert[1..-1].map { |chain| OpenSSL::X509::Certificate.new(chain).subject.to_s }
                   else
                     [crt.issuer.to_s]
                   end

    valid_from = crt.not_before
    valid_to   = crt.not_after
    hash = crt.hash.to_s

    asn_crt = OpenSSL::ASN1.decode(crt)
    signature = asn_crt.value[2].value.unpack('H*')[0]

    cert = Cert.new({ :subject_dn => subject,
      :signers => signers,
                      :cert_hash => hash,
                      :valid_from => valid_from,
                      :valid_to => valid_to,
                      :signature => signature})
    cert.update_sha

    cert.save!

    return cert
  end

  def self_signed?
    self.issuer and self.issuer == self
  end

  def self.calc_sha( cert )
    hash = Digest::SHA256.new
    hash << cert.subject_dn if cert.subject_dn
    hash << cert.valid_from.iso8601 if cert.valid_from
    hash << cert.valid_to.iso8601 if cert.valid_to
    return hash.hexdigest
  end

  #
  #
  #
  def ==(other)
    return false unless other.is_a?(X509)
    return false unless self.valid? == other.valid?
    return self._id == other._id
    # return self.sha == other.sha
  end

  protected

  #
  #
  #
  def duplicate?
    dupes = Cert.where.and(:subject_dn=>self.subject_dn,
    :signers=>self.signers,
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
    # calculate the sha if a value has been changed
    self.sha = Cert.calc_sha(self) #if self.changed?
  end

end

