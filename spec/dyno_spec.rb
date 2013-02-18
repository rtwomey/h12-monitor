require 'spec_helper'
require 'dyno'

describe Dyno do
  context 'MAX_ALLOWED_ERROR_COUNT' do
    it 'should be the correct value' do
      Dyno::MAX_ALLOWED_ERROR_COUNT.should == 3
    end
  end

  context 'when a dyno reports an H12' do
    before do
      @heroku_connection = stub
      @heroku_connection.stub post_ps_restart: true
    end

    context 'and this is the first reported error' do
      before do
        @dyno = Dyno.new(@heroku_connection, 'myapp', 'web.1')
        @dyno.handle_h12
      end

      it 'should not restart the dyno' do
        @heroku_connection.should_not have_received(:post_ps_restart)
      end
    end

    context 'and this is the max allowed error' do
      before do
        @dyno = Dyno.new(@heroku_connection, 'myapp', 'web.1')

        Dyno::MAX_ALLOWED_ERROR_COUNT.times do
          @dyno.handle_h12
        end
      end

      it 'should restart the dyno' do
        @heroku_connection.should have_received(:post_ps_restart).with('myapp', ps: 'web.1')
      end
    end
  end
end
