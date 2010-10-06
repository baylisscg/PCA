#
#
#

=begin

=end

class Event
  include Mongoid::Document
  
  field :action
  field :created_at, :type => DateTime 

#  index [[:action,Mongo::DESCENDING],[:created_at,Mongo::DESCENDING ]], :unique => true
  
  embedded_in :connection, :inverse_of => :events

#  belongs_to_related :connection, :inverse_of=>:events

  named_scope :modified_in, lambda { |seconds| where(:created_at.gt => (Time.now-seconds).utc) }
    
  def elapsed
    Time.now - self.created_at
  end
  
end

