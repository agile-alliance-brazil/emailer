# encoding:UTF-8

# Certifier VERSION holder
module Mailer
  def self.version
    VERSION::STRING
  end

  module VERSION
    MAJOR = 0
    MINOR = 1
    TINY = 0
    PRE = 'beta'.freeze
    STRING = [MAJOR, MINOR, TINY, PRE].compact.join('.')
  end
end
