# encoding: utf-8
#
#

require "bson"
require "nokogiri"

module EntityMixin

  #
  # 
  #
  def make_tag
    "tag:#{Entity::TAG_BASE}:#{self.class.name}/#{self._id.to_s}"
  end

end


class Entity
  include Mongoid::Document
  include EntityMixin

  TAG_BASE = "pca.nesc.gla.ac.uk,2011"

  Object_Type = "http://entity"

  field :tag # id equivalent
  field :name
  field :summary
  field :permalink
  field :object_type

  validates_presence_of :tag, :message=>"Tag is blank"
  validates_presence_of :object_type, :message=>"Object type is blank"

  [:_type, :_id, :tag, :object_type].each { |f| index f }

  set_callback(:validation, :before) do |doc|
    doc.object_type = self.class::Object_Type unless doc.object_type
    doc.tag = doc.make_tag unless doc.tag
    doc.name = doc.class.name unless doc.name
  end

  def to_s
    sprintf "tag:%s\nobject type:%s\nname:%s\nsummary:%s\npermalink:%s", tag, object_type, name, summary, permalink
  end

  def to_atom(args={})
    raise NotImplementedError, "Entity#to_atom called. This does not make sense."
  end

  def to_yaml(args={})
    raise NotImplementedError, "Entity#to_yaml called. This does not make sense."
  end

end
