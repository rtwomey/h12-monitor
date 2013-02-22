require 'uri'
require 'net/http'

class HerokuLogStreamer
  OPEN_TIMEOUT = 5
  READ_TIMEOUT = 10

  def initialize(heroku_connection, app_name, heroku_opts={})
    @heroku_connection = heroku_connection
    @app_name = app_name
    @heroku_opts = heroku_opts
  end

  def stream(&block)
    begin
      MonitorLogger.info "Connecting to Heroku logplex for #{@app_name}."

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
      MonitorLogger.error "Timeout in Heroku logs (#{e.message}). Retrying"
      retry
    rescue Errno::ECONNREFUSED
      MonitorLogger.error 'Failed to connect to Heroku logplex. Retrying'
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
      http.open_timeout = OPEN_TIMEOUT
      http.read_timeout = READ_TIMEOUT
    end
  end
end
