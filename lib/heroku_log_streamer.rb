require 'uri'
require 'net/http'

class HerokuLogStreamer
  def initialize(heroku_connection, app_name, heroku_opts={})
    @heroku_connection = heroku_connection
    @app_name = app_name
    @heroku_opts = heroku_opts
  end

  def stream(&block)
    begin
      puts "Connecting to Heroku logplex for #{@app_name}."

      request.start do
        path = heroku_log_url.path + (heroku_log_url.query ? "?" + heroku_log_url.query : "")

        request.request_get(path) do |request|
          request.read_body do |chunk|
            chunk.split("\n").each do |line|
              yield line
            end
          end
        end
      end
    rescue Timeout::Error => e
      puts "Timeout in Heroku logs (#{e.message}). Retrying"
      retry
    end
  end

  private

  def heroku_log_url
    @url ||= URI.parse(@heroku_connection.get_logs(@app_name, @heroku_opts).body)
  end

  def request
    @http ||= Net::HTTP.new(heroku_log_url.host, heroku_log_url.port).tap do |http|
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  end
end
