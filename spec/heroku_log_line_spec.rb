require 'spec_helper'
require 'heroku_log_line'

describe HerokuLogLine do
  context 'with an h12' do
    before do
      log_entry = '2013-02-15T16:33:09+00:00 heroku[router]: at=error code=H12 desc="Request timeout" method=GET path=/some_url host=www.myapp.com fwd="1.2.3.4, 9.8.7.6" dyno=web.15 queue=0ms wait=2ms connect=3196ms service=30001ms status=503 bytes=0'
      @log_line = HerokuLogLine.new(log_entry)
    end

    it 'should recognize this is an H12' do
      @log_line.h12?.should be_true
    end

    it 'should return the correct dyno' do
      @log_line.dyno.should == 'web.15'
    end
  end

  context 'with a non-h12' do
    before do
      log_entry = "2013-02-17T18:19:20+00:00 heroku[router]: at=info method=GET path=/some_url host=www.myapp.com fwd=\"1.2.3.4, 9.8.7.6\" dyno\n=web.10 queue=0 wait=0ms connect=1ms service=107ms status=200 bytes=1029"
      @log_line = HerokuLogLine.new(log_entry)
    end

    it 'should recognize this is not an H12' do
      @log_line.h12?.should be_false
    end

    it 'should return the correct dyno' do
      @log_line.dyno.should == 'web.10'
    end
  end
end
