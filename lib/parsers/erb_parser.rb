require 'erb'

# Encapsulates the ERB parser
class ErbParser
  def initialize(content)
    @parser = ERB.new(content)
  end

  def parse_using(namespace)
    @parser.result(namespace.instance_eval { binding })
  end
end
