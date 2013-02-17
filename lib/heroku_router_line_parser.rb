class HerokuRouterLineParser
  def initialize(line)
    @line = line
  end

  def parse
    if heroku_router_entry?
      split_line_to_hash
    end
  end

  private

  def decompose_to_pairs
    @line.gsub("\n", '').split(' ').map { |pair| pair.split('=') }
  end

  def heroku_router_entry?
    @line =~ /heroku\[router\]/
  end

  def split_line_to_hash
    decompose_to_pairs.inject({}) do |acc, (a, b)|
      acc[a] = b
      acc
    end
  end
end
