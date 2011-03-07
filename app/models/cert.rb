# encoding: utf-8
#

require 'uri'
require 'cgi'
require 'digest/sha1'
require 'openssl'

#
# Extends credential to support X509 public keys.
#
class Cert < Credential
  include Dn

  field :subject_dn, :index => true, :background => true
  field :cert_hash   # The hash of the certificate
  field :proxy,      :type=>Boolean, :default=>false # True if a RFC proxy
  
  referenced_in   :issuer, :class_name => "Cert", :inverse_of=> :signed
  references_many :signed, :class_name => "Cert", :inverse_of=> :issuer, :foreign_key => :issuer_id, :validate => false # Only automatically validate  up the hierarchy to avoid infinite loops 

  field :cert # The cert as a pem file.

  index :issuer

  validates_presence_of :subject_dn, :issuer, :cert_hash

  #
  #
  #
  def to_s
    out = ""
    out <<         "subject: " << self.subject_dn
    out << "\n" << "issuer: " << self.issuer.subject_dn
    out << "\n" << "issuer_chain: " << self.issuer_chain.map {|cert| cert.subject_dn }.join(", ")
    out << "\n" << "hash: " << self.cert_hash
    return out
  end

  #
  #
  #
  def issuer_cert
    Cert.criteria.where(:subject_dn=>self.issuer).all
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

  def issuer_chain
    Enumerator.new do |x|
      temp = self.issuer
      x.yield temp if temp
      while not temp.self_signed? do
        temp = temp.issuer
        x.yield temp if temp
      end
    end
  end

  def self_signed?
    self.issuer and self.issuer == self
  end

  def Cert.calc_sha( cert )
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
    return false unless other.is_a?(Cert)
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

