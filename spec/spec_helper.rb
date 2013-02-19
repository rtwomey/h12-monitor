$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rspec'
require 'rspec/autorun'
require 'rspec-spies'
require 'heroku-api'
require 'webmock/rspec'

require 'monitor_logger'
MonitorLogger.instance.logger.level = Logger::FATAL

WebMock.disable_net_connect!

RSpec.configure do |config|
end
