require 'singleton'
require 'logger'

class MonitorLogger
  include Singleton

  attr_accessor :logger

  def initialize
    self.logger = Logger.new(STDOUT)
    logger.level = Logger::INFO
  end

  def self.info(message)
    logger.info message
  end

  def self.warn(message)
    logger.warn message
  end

  def self.error(message)
    logger.error message
  end

  private

  def self.logger
    MonitorLogger.instance.logger
  end
end
