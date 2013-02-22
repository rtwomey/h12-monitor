require 'spec_helper'
require 'heroku_log_streamer'

describe HerokuLogStreamer do
  context 'OPEN_TIMEOUT' do
    it 'should be expected' do
      HerokuLogStreamer::OPEN_TIMEOUT.should == 5
    end
  end

  context 'READ_TIMEOUT' do
    it 'should be expected' do
      HerokuLogStreamer::READ_TIMEOUT.should == 10
    end
  end

  context 'stream' do
    before do
      @heroku_connection = stub get_logs: stub(body: heroku_logs_uri)
      @logs_request = stub_request(:get, heroku_logs_uri).to_return(status: 200)

      @logger = stub_logger
      @logger.stub(:info)

      @streamer = HerokuLogStreamer.new(@heroku_connection, 'myapp', tail: '1')
      @streamer.stream
    end

    it 'should connect to the correct URI' do
      @logs_request.should have_been_requested
    end

    it 'should log a connection message' do
      @logger.should have_received(:info).with('Connecting to Heroku logplex for myapp.')
    end

    pending 'should yield with log line'
    pending 'should retry on timeout error'
    pending 'should retry on connection error'
  end

  private

  def heroku_logs_uri
    'https://api.heroku.com/apps/myapp/logs?logplex=true&tail=1'
  end

  def stub_logger
    stub(Logger).tap do |logger|
      MonitorLogger.stub_chain :instance, logger: logger
    end
  end
end
