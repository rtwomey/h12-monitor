require 'spec_helper'

describe MonitorLogger do
  before do
    @stub = stub(Logger)
    Logger.stub! new: @stub
    MonitorLogger.stub_chain :instance, logger: @stub
  end

  after do
    Logger.unstub :new
  end

  context 'info' do
    before do
      stub_log_method @stub, :info
    end

    it 'logs an info message' do
      @stub.should have_received(:info).with('info message')
    end
  end

  context 'warn' do
    before do
      stub_log_method @stub, :warn
    end

    it 'logs a warning message' do
      @stub.should have_received(:warn).with('warn message')
    end
  end

  context 'error' do
    before do
      stub_log_method @stub, :error
    end

    it 'logs an error message' do
      @stub.should have_received(:error).with('error message')
    end
  end

  private

  def stub_log_method(stub, method_name)
    stub.stub method_name
    MonitorLogger.send method_name, "#{method_name} message"
  end
end
