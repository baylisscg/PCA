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

  field "valid_from", :type=> Time
  field "valid_to", :type => Time
 
  belongs_to :user,        :class_name => "User",     :inverse_of=> :credentials
  has_many   :connections, :class_name=>"Connection", :inverse_of=> :credential
 
  # As we cannot save invalid certificates to only sanity check the dates.
  validate :time_valid 

  # Index the "user" column
  index :user_id

  #
  # Time is valid if either both valid_from and valid_to are nil or
  # both are set and valid_from is before valid_to. 
  #
  def time_valid
    if self.valid_from and self.valid_to then
      errors.add(:valid_from,
      "must be before the valid to date. #{self.valid_from} >= #{self.valid_to}") unless self.valid_from < self.valid_to
    else
      if self.valid_from or self.valid_to then
        errors.add(:valid_from,
        " must be set when valid_to is set.") unless self.valid_from
        errors.add(:valid_to,
        " must be set when valid_from is set.") unless self.valid_to
      end
    end
  end

  #
  # True if the 
  #
  def expired?
    now = Time.now
    return true unless self.valid_from && self.valid_from <= now
    return true unless self.valid_to && now <= self.valid_to
    return false
  end

  # Because we need to access subclasses of Credential this function is hived off into a
  # seperate module to avoid circular dependencies.
#  def self.(args)
#    PCA::Credential::Tools.find_or_make(args)
#  end

  #
  #
  #
  def self.find_or_initialize(args)
    {"x509" => Cert }[args["type"]].find_or_initialize_by(args)
  end
  
end

