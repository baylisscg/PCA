# encoding: utf-8
#
#

require 'bson'


module EntityMixin

  def set_object_type
    self.object_type = self.class::Object_Type
  end

end


class Entity
  include Mongoid::Document
  include EntityMixin

  Object_Type = "http://entity"

  field :tag # id equivalent
  field :name
  field :summary
  field :permalink
  field :object_type

  [:_type, :_id, :tag, :object_type].each {|f| index f }

  set_callback(:create,:before) do |doc|
    set_object_type
  end

end
