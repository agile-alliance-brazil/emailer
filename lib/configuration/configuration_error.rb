# encoding:UTF-8

# Represents a configuration error
class ConfigurationError < StandardError
  def initialize(message)
    super(message)
  end
end
