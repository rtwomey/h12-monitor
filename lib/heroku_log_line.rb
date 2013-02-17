require 'heroku_router_line_parser'

class HerokuLogLine
  def initialize(line)
    @parsed_line = HerokuRouterLineParser.new(line).parse
  end

  def h12?
    @parsed_line && router_reports_h12?
  end

  def dyno
    if @parsed_line
      @parsed_line['dyno']
    end
  end

  private

  def router_reports_h12?
    @parsed_line['code'] == 'H12'
  end
end
