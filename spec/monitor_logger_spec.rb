require 'spec_helper'

describe MonitorLogger do
  before do
    @logger = stub(Logger)
    Logger.stub! new: @logger
    MonitorLogger.stub_chain :instance, logger: @logger
  end

  after do
    Logger.unstub :new
  end

  context 'info' do
    before do
      stub_log_method @logger, :info
    end

    it 'logs an info message' do
      @logger.should have_received(:info).with('info message')
    end
  end

  context 'warn' do
    before do
      stub_log_method @logger, :warn
    end

    it 'logs a warning message' do
      @logger.should have_received(:warn).with('warn message')
    end
  end

  context 'error' do
    before do
      stub_log_method @logger, :error
    end

    it 'logs an error message' do
      @logger.should have_received(:error).with('error message')
    end
  end

  private

  def stub_log_method(stub, method_name)
    stub.stub method_name
    MonitorLogger.send method_name, "#{method_name} message"
  end
end
