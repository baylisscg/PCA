#
#
#

require "java"
require "#{Rails.root}/lib/jars/slf4j-api-1.6.1.jar"
require "#{Rails.root}/lib/jars/slf4j-simple-1.6.1.jar"


class Logger
  
#  java_import org.slf4j.Logger
#  java_import org.slf4j.LoggerFactory
  
  #
  #
  #
  
  
  @@loggers = {}
  
  def initialize(name)
    @logger = Java::OrgSlf4j::LoggerFactory.get_logger(name.to_str)
    @@loggers[name.to_str] = @logger
  end

  def info(message,*args)
    @logger.info message, args
  end
  
  def debug(message,*args)
    @logger.debug message, args
  end

  def self.get_logger(name)
    @@loggers[name.to_str] if  @@loggers[name.to_str]
    Logger.new(name.to_str)
  end

end
