=begin
=end

require 'pca/time'

class Connection
  include Mongoid::Document
  include Mongoid::Timestamps
  include TimeTools
    
  field :server
  field :peer
  field :conn_id
  field :cred_id  # manual connection to Cert
  
  embeds_many :events, :class_name => "Event"

  validates_presence_of :server, :peer
  
  index [[:server, Mongo::ASCENDING ],[:peer, Mongo::ASCENDING  ],[:conn_id, Mongo::ASCENDING ]], :unique => true

  index :updated_at
  index :created_at
  index :cred_id
  index ["events.action", Mongo::DESCENDING]
  index [["events.action",Mongo::DESCENDING],["events.created_at",Mongo::DESCENDING ]], :unique => true  

  named_scope :event_within, lambda { |sec| where(:updated_at => { "$gt"=>(Time.now-sec).utc}) }

  named_scope :started_after,  lambda { |after|  {:where => {:created_at.gt => after }}}
  named_scope :started_before, lambda { |before| {:where => {:created_at.lt => before }}} 
  
  named_scope :uses_cert, lambda { |cert| where( :cred_id => cert) }
  
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
  
  def cred
    Cert.criteria.id(self.cred_id).first
  end
  
  def cred=(id)
      self.cred_id=id
  end
  
  def to_id
    self.server + " <=> " + self.peer
  end
 
  def self.do_tag_count()
    m = 'function(){ this.events.forEach( function(z){ emit( z.action , { count : 1 } ); } ); };'
    r = <<-REDUCE
function( key , values ){
  var total = 0;
  for ( var i=0; i < values.length; i++ )
    total += values[i].count;
  return { count : total };
};
REDUCE
    Connection.collection.map_reduce(m,r)
  end

end
