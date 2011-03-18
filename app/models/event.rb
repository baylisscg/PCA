#
#
#

=begin

=end

class Event
  include Mongoid::Document

  class EventTypeNotFound < NameError; end

  field :action, :type => String
  field :parent, :type => BSON::ObjectId
  field :created_at, :type => DateTime, :default => DateTime.now

#  index [[:action,Mongo::DESCENDING],[:created_at,Mongo::DESCENDING ]], :unique => true

  embedded_in :connection, :inverse_of => :events

  validates_presence_of :action, :created_at

  @@known_events = {}

#  belongs_to_related :connection, :inverse_of=>:events

  named_scope :modified_in, lambda { |seconds| where(:created_at.gt => (Time.now-seconds).utc) }

  def elapsed
    Time.now - self.created_at
  end

  def root?
    self.parent.nil?
  end

  def children
    Event.where(:parent=>self._id)
  end

  def get_verbs
    ["http://activitystrea.ms/schema/1.0/post",
    "http://pca.nesc.gla.ac.uk/%s" % self.action]
  end

  #
  #
  # 
  def self.make(args)
    name = args[:action]
    c = @@subclasses[name]
    if c
      c.new
    else
      raise EventTypeNotFound.new "Unknown event type: #{name}"
    end
  end

  #
  # Used by event subclasses to register themselves
  # 
  def self.register_event(name)
    @@known_events[name] = self
  end

  #
  # Helper to register new Event types
  #
  def self.create_event( name, superclass=Event, &block )
    new_class = Class.new(superclass, &block)
    new_class.register_event(name)
    new_class.const_set("#{name.to_s.capitalize}Event", c)
  end

end


