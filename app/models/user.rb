# encoding: utf-8
#
#

require 'bson'

class User < Person

#  devise :omniauthable

  Object_Type = "http://pca.nesc.gla.ac.uk/schema/objects/user"
  
  has_many :credentials, :class_name => "Credential", :inverse_of => :user
  references_many :authentications, :dependent => :delete

  embeds_many :authentication_mechanisms

  index ["authentication_mechanisms.provider","authentication_mechanisms.uid"], :unique => true

  #
  #
  #
  def self.find_via_omniauth(args)
    # Look up via authentication URI
    provider = args[:provider]
    uid = args[:uid]
    user_info = args[:user_info]

    user = User.where("authentication_mechanisms.provider"=>provider,"authentication_mechanisms.uid"=>uid).first
    logger.info "User #{user} from #{uid}@#{provider}"

    user ||= User.where(:first_name=> user_info[:first_name],
                        :last_name=> user_info[:last_name],
                        :name=> user_info[:name])
    logger.info "User #{user} from #{user_info}"

    user ||= User.make_from_omniauth(provider,uid,user_info)

  end

  protected

  def self.make_from_omniauth(provider,uid,user_info)
    logger.info "Making new user #{user_info.name} from #{uid}@#{provider}"
    user = User.new(user_info)
    user.authentication_mechanisms << Authentication.new(:provider=>provider,:uid=>uid)
    user.save
    return user
  end

end
