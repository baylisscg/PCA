# encoding: utf-8
#
#

require "bson"
require "nokogiri"

class Entity
  include Mongoid::Document

  TAG_BASE = "pca.nesc.gla.ac.uk,2011"

  Object_Type = "http://entity"

  field :tag # id equivalent
  field :name
  field :summary
  field :permalink
  field :object_type

  validates_presence_of :tag, :message=>"Tag MUST NOT be blank"
  validates_presence_of :object_type, :message=>"Object type MUST NOT be blank"

  [:_type, :_id, :tag, :object_type].each { |f| index f }

  set_callback(:validation, :before) do |r|
    r.make_name
    r.make_tag
    r.make_object_type
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

  def as_json(options={})
    hash = { :tag=>self.tag,
      :name=>self.name,
      :object_type=>self.object_type,
    }
    hash[:summary] = self.summary if self.summary
    hash
  end


  protected
  #
  # 
  #
  def make_tag
    self.tag = "tag:#{Entity::TAG_BASE}:#{self.name}/#{self._id.to_s}" unless self.tag
  end

  def make_name
    self.name = self.class.name unless self.name
  end

  def make_object_type
    self.object_type = self.class::Object_Type unless self.object_type
  end

end
