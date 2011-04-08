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

  validates_presence_of :action, :created_at

  named_scope :modified_in, lambda { |seconds| where(:created_at.gt => (Time.now-seconds).utc) }

  def elapsed
    Time.now - self.created_at
  end

  def root?
    self.parent.nil?
  end

#  def children
#    Event.where(:parent=>self._id)
#  end


  #
  #
  # 
  # def self.make(args)
  #   name = args[:action]
  #   c = @@subclasses[name]
  #   if c
  #     c.new
  #   else
  #     raise EventTypeNotFound.new "Unknown event type: #{name}"
  #   end
  # end

  #
  # Used by event subclasses to register themselves
  # 
  # def self.register_event(name)
  #   @@known_events[name] = self
  # end

  #
  # Helper to register new Event types
  #
  # def self.create_event( name, superclass=Event, &block )
  #   new_class = Class.new(superclass, &block)
  #   new_class.register_event(name)
  #   new_class.const_set("#{name.to_s.capitalize}Event", c)
  # end

end


