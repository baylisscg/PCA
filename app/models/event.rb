#
#
#

=begin

=end

class Event < Entity

  Object_Type = "http://pca.nesc.gla.ac.uk/schema/objects/event"

  class EventTypeNotFound < NameError; end

  field :action, :type => String, :index=>true
  field :created_at, :type => DateTime, :default => DateTime.now, :index=>true

  has_many   :children,   :class_name=>"Event",      :inverse_of=>:parent
  belongs_to :parent,     :class_name=>"Event",      :inverse_of=>:children
  belongs_to :connection, :class_name=>"Connection", :inverse_of => :events

  validates_presence_of :action, :created_at, :connection

  named_scope :modified_in, lambda { |seconds| where(:created_at.gt => (Time.now-seconds).utc) }

  def as_json(options={})
    out = super(options)
    out[:action] = self.action
    out[:created_at] = self.created_at
    out[:connection] = self.connection._id
    out[:parent] = self.parent._id if self.parent
    out[:children] = self.children.map { |child| child._id } if self.children and not self.children.empty?
    out
  end

  def elapsed
    Time.now - self.created_at
  end

  def root?
    self.parent.nil?
  end

  def self.do_tag_count()
    m = <<-MAP
function(){
  this (
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

end


