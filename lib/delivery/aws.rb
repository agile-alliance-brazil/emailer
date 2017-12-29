# encoding:UTF-8
require 'aws/ses'

# Delivery module holds multiple delivery options
module Delivery
  # Represents a delivery using AWS::SES
  class AWS
    def initialize(key_id, secret, server = nil)
      @key_id = key_id
      @secret = secret
      @server = server
    end

    def complete?
      @key_id && @secret
    end

    def error_messages
      return nil if complete?

      message = "There are problems with your AWS configuration:\n"
      message += build_specific_messages
      message
    end

    def id
      :ses
    end

    def to_hash
      hash = {
        access_key_id: @key_id,
        secret_access_key: @secret
      }
      hash[:server] = @server if @server
      hash
    end

    def install_on(action_mailer)
      action_mailer.add_delivery_method id, ::AWS::SES::Base, to_hash
      action_mailer.delivery_method = id
    end

    private

    def build_specific_messages
      message = ''
      message += missing_key_message unless @key_id
      message += missing_secret_message unless @secret
      message
    end

    def missing_key_message
      build_error_message('access key ID', 'AWS_ACCESS_KEY_ID')
    end

    def missing_secret_message
      build_error_message('secret access key', 'AWS_SECRET_ACCESS_KEY')
    end

    def build_error_message(name, variable)
      "Missing AWS #{name}. Please define an environment variable with key \
  name '#{variable}' or add that entry to your .env file."
    end
  end
end
