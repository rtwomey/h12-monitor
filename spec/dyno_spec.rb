require 'rspec'
require File.expand_path('../../lib/dyno', __FILE__)

describe Dyno do
  context 'MAX_ALLOWED_ERROR_COUNT' do
    it 'should be the correct value' do
      Dyno::MAX_ALLOWED_ERROR_COUNT.should == 3
    end
  end

  context 'when a dyno reports an H12' do
    before do
      @heroku_connection = stub
    end

    context 'and this is the first reported error' do
      before do
        @dyno = Dyno.new(@heroku_connection, 'myapp', 'web.1')
        @dyno.handle_h12
      end

      pending 'should not restart the dyno'
    end

    context 'and this is the max allowed error' do
      before do
        @dyno = Dyno.new(@heroku_connection, 'myapp', 'web.1')

        Dyno::MAX_ALLOWED_ERROR_COUNT.times do
          @dyno.handle_h12
        end
      end

      pending 'should restart the dyno'
    end
  end
end
