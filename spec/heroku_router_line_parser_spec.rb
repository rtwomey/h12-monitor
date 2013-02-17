require 'rspec'
require File.expand_path('../../lib/heroku_router_line_parser', __FILE__)

describe HerokuRouterLineParser do
  context 'with a router log entry' do
    context 'with a non-H12 entry' do
      context 'without line breaks' do
        before do
          log_entry = '2013-02-17T17:59:50+00:00 heroku[router]: at=info method=GET path=/ host=www.myapp.com fwd="1.2.3.4, 9.8.7.6" dyno=web.3 queue=0 wait=4ms connect=4ms service=729ms status=200 bytes=13057'
          @result = HerokuRouterLineParser.new(log_entry).parse
        end

        it 'should return the correct hash' do
          @result.should == {"2013-02-17T17:59:50+00:00"=>nil, "heroku[router]:"=>nil, "at"=>"info",
            "method"=>"GET", "path"=>"/", "host"=>"www.myapp.com", "fwd"=>"\"1.2.3.4,",
            "9.8.7.6\""=>nil, "dyno"=>"web.3", "queue"=>"0", "wait"=>"4ms", "connect"=>"4ms",
            "service"=>"729ms", "status"=>"200", "bytes"=>"13057"}
        end
      end

      context 'with a line break' do
        before do
          log_entry = "2013-02-17T18:19:20+00:00 heroku[router]: at=info method=GET path=/some_url host=www.myapp.com fwd=\"1.2.3.4, 9.8.7.6\" dyno\n=web.10 queue=0 wait=0ms connect=1ms service=107ms status=200 bytes=1029"
          @result = HerokuRouterLineParser.new(log_entry).parse
        end

        it 'should return the correct hash' do
          @result.should == {"2013-02-17T18:19:20+00:00"=>nil, "heroku[router]:"=>nil,
            "at"=>"info", "method"=>"GET", "path"=>"/some_url", "host"=>"www.myapp.com",
            "fwd"=>"\"1.2.3.4,", "9.8.7.6\""=>nil, "dyno"=>"web.10", "queue"=>"0", "wait"=>"0ms",
            "connect"=>"1ms", "service"=>"107ms", "status"=>"200", "bytes"=>"1029"}
        end
      end
    end

    context 'with an H12 entry' do
      before do
        log_entry = '2013-02-15T16:33:04+00:00 heroku[router]: at=error code=H12 desc="Request timeout" method=GET path=/some_url host=www.myapp.com fwd=1.2.3.4 dyno=web.15 queue=0ms wait=0ms connect=4085ms service=30001ms status=503 bytes=0'
        @result = HerokuRouterLineParser.new(log_entry).parse
      end

      it 'should return the correct hash' do
        @result.should == {"2013-02-15T16:33:04+00:00"=>nil, "heroku[router]:"=>nil,
          "at"=>"error", "code"=>"H12", "desc"=>"\"Request", "timeout\""=>nil, "method"=>"GET",
          "path"=>"/some_url", "host"=>"www.myapp.com", "fwd"=>"1.2.3.4", "dyno"=>"web.15",
          "queue"=>"0ms", "wait"=>"0ms", "connect"=>"4085ms", "service"=>"30001ms",
          "status"=>"503", "bytes"=>"0"}
      end
    end
  end

  context 'with a web app log entry' do
    context 'on a Rails-emitted notice' do
      before do
        log_entry = '2013-02-17T17:52:47+00:00 app[web.13]: unhandled braintree card error: #<Braintree::Errors >'
        @result = HerokuRouterLineParser.new(log_entry).parse
      end

      it 'should return nil' do
        @result.should be_nil
      end
    end

    context 'on a Rails-emitted error' do
      before do
        log_entry = '2013-02-17T17:52:49+00:00 app[web.15]: ActionController::RoutingError (No route matches [GET] "/assets/favicon.png"):'
      end

      it 'should return nil' do
        @result.should be_nil
      end
    end

    context 'on an app-emitted notice' do
      before do
        log_entry = '2013-02-17T17:52:47+00:00 app[web.13]: unhandled braintree card error: #<Braintree::Errors >'
      end

      it 'should return nil' do
        @result.should be_nil
      end
    end
  end

  context 'with a postgres log entry' do
    before do
      log_entry = <<-eoline
        2013-02-17T17:58:43+00:00 app[postgres]: [440-1] 193dLrm2j0mh9A [BLUE] LOG:  duration: 132.483 ms  statement: SELECT COUNT(*) FROM 'users'
      eoline
    end

    it 'should return nil' do
      @result.should be_nil
    end
  end
end
