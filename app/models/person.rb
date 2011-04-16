# encoding: utf-8
#
#
#

require 'bson'

#
# The Crednetial class models the basic credential
# with a validity period. Specific crednetial 
# implementations extend this class.
#
class Person < Entity
  
  Object_Type = "http://activitystrea.ms/schema/1.0/person"
  
  field :name
  field :first_name
  field :last_name
  field :url

  before_save  :update_name
  
  after_create :update_name
  after_update :update_name

  protected

  def make_name
    "#{self.first_name} #{self.last_name}"
  end

  def update_name
    self.name = make_name unless self.name
  end

end
