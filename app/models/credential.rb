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
class Credential < Entity

  Object_Type = "http://pca.nesc.gla.ac.uk/schema/object/credential"
 
  belongs_to :user,        :class_name => "User",     :inverse_of=> :credentials
  has_many   :connections, :class_name => "Connection", :inverse_of=> :credential
 
  #
  #
  #
#  def self.find_or_initialize(args)
#    {"x509" => Cert }[args["type"]].find_or_initialize_by(args)
#  end
  
  def as_json(options={})
    hash = super(options)
    hash[:user] = self.user if self.user
    hash[:connections] = self.connections.all if self.connections
    return hash
  end

  def last_event_at
    self.last_event.updated_at
  end

  def last_event
    
    def test(best,current)
      if best.last_event > current.last_event
        puts "#{best.last_event} > #{ current.last_event}"
        best
      else
        puts "#{best.last_event} < #{ current.last_event}"
        current
      end 
    end

    x,*xs = self.connections
    puts "HI"
    xs.inject(x) { |(best,current)| test(best,current) }
  end

end

