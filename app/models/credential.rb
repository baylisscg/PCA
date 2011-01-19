=begin
=end

require 'bson'

class Credential
  include Mongoid::Document

  field "valid_from", :type=> Time
  field "valid_to", :type => Time

  #
  #
  #
  #  def initialize(args={})
  #  self.valid_from = args[:valid_from] if args[:valid_from]
  #  self.valid_to = args[:valid_to] if args[:valid_to]
  #end
  
  validate :time_valid

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
  #
  #
  def expired?
    now = DateTime.now
    return true unless self.valid_from && self.valid_from <= now
    return true unless self.valid_to && now <= self.valid_to
    return false
  end

end

