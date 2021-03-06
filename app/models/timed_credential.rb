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
class TimedCredential < Credential

  Object_Type = "http://pca.nesc.gla.ac.uk/schema/object/timed_credential"

  field "valid_from", :type=> Time
  field "valid_to", :type => Time
  
  # As we cannot save invalid certificates to only sanity check the dates.
  validate :time_valid

  def as_json(options={})
    hash = super(options)
    hash[:valid_from] = self.valid_from if self.valid_from
    hash[:valid_to] = self.valid_to if self.valid_to
    return hash
  end

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
  
end
