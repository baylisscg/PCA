# encoding: utf-8
#
#

require 'bson'
require 'pca/time'

class Connection < Entity
  include TimeTools

  Object_Type = "http://pca.nesc.gla.ac.uk/schema/object/connect"

  field :server
  field :peer

  belongs_to :credential, :class_name => "Credential", :inverse_of=> :connections
  has_many :events, :class_name => "Event", :inverse_of=>:connection

  validates_presence_of :server, :peer

  index [[:server, Mongo::ASCENDING ],[:peer, Mongo::ASCENDING  ],[:_id, Mongo::ASCENDING ]], :unique => true

  named_scope :event_within, lambda { |sec| where(:updated_at => { "$gt"=>(Time.now-sec).utc}) }
  named_scope :started_after,  lambda { |after|  {:where => {:created_at.gt => after }}}
  named_scope :started_before, lambda { |before| {:where => {:created_at.lt => before }}}
  named_scope :uses_cert, lambda { |cert| where( :cert_id => cert._id) }


  before_save :check_cred

  def created_at; self.first_event.created_at end
  def updated_at; self.last_event.created_at end

  def last_event
    self.events.ascending(:created_at).first
  end

  def first_event
    self.events.descending(:created_at).first
  end

  def self.within(args)
    query = { }
    query["$lt"] = Time.parse(args[:before]) if args[:before]
    query["$gt"] = Time.parse(args[:after]) if args[:after]

    if query.empty? then
      query
    else
      puts "Query = #{query}"
      where(:created_at => query )
    end
  end

  #
  #
  # 
#  def cert
#    Cert.criteria.id(self.cert_id).first
#  end

  #
  #
  #
#  def cert=(cert)
#    if cert.kind_of? Cert
#      id = cert._id
#    else
#      id = cert
#      cert = Cert.id(cert)
#    end
#    self.cert_id = id
#  end

  def to_id
    self.server + " <=> " + self.peer
  end

  def self.do_tag_count()
    m = <<-MAP
function(){
  this.events.forEach(
    function(z){
      emit( z.action , { count : 1 } );
    }
  );
};
MAP

    r = <<-REDUCE
function( key , values ){
  var total = 0;
  for ( var i=0; i < values.length; i++ )
    total += values[i].count;
  return { count : total };
};
REDUCE

    result = Connection.collection.map_reduce(m,r,:verbose=>true,:sort=>[["value.count",Mongo::DESCENDING]])

    return result
  end

  protected

  #
  #
  #
  def check_cred
    errors.add(:cert,"Supplied cert id does not exist.") unless self.credential
  end

  #
  #
  #
  def update_cert
    cret.connections << self
    cred.save
  end


end
