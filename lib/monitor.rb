require 'heroku_log_streamer'
require 'heroku_log_line'
require 'dyno'

class Monitor
  def initialize(app_name, heroku_api_key)
    @app_name = app_name
    @heroku_api_key = heroku_api_key
    @dynos = {}
  end

  def monitor
    streamer = HerokuLogStreamer.new(heroku_connection, @app_name, tail: '1', ps: 'router')

    streamer.stream do |line|
      log_line = HerokuLogLine.new(line)

      if dyno_name = log_line.dyno
        @dynos[dyno_name] ||= Dyno.new(heroku_connection, @app_name, dyno_name)

        if log_line.h12?
          @dynos[dyno_name].handle_h12
        else
          @dynos[dyno_name].reset_error_count
        end
      else
        puts "malformed line: #{line}"
      end

      update_line_statistics
    end
  end

  private

  def heroku_connection
    @heroku_connection ||= Heroku::API.new(api_key: @heroku_api_key)
  end

  def update_line_statistics
    @line_counter ||= 0
    @line_counter += 1

    if @line_counter % 50 == 0
      puts "#{@app_name}: monitored #{@line_counter} lines, #{@dynos.count} dynos reporting"
    end
  end
end
