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

end


