# encoding:UTF-8
require 'json'

module Delivery
  # Represents an SMTP delivery
  class SMTP
    def initialize(settings)
      @settings = settings
    end

    def complete?
      (@settings[:address] &&
        @settings[:user_name] &&
        @settings[:domain] &&
        @settings[:password])
    end

    def id
      :smtp
    end

    def error_messages
      return nil if complete?

      message = "There are problems with your SMTP server configuration:\n"
      message += message_for(:address, 'SMTP_SERVER')
      if !@settings['SMTP_USERNAME'] && !@settings['SENDER']
        message += message_for(:user_name, 'SMTP_USERNAME')
      end
      message += message_for(:domain, 'SENDER')
      message += message_for(:password, 'SMTP_PASSWORD')
      message
    end

    def to_hash
      @settings
    end

    def install_on(action_mailer)
      action_mailer.smtp_settings = to_hash
      action_mailer.delivery_method = id
    end

    private

    def message_for(key, environment_key)
      if @settings[key]
        ''
      else
        "Missing SMTP #{key}. Please define an environment variable with key \
name '#{environment_key}' or add that entry to your .env file.\n"
      end
    end
  end
end
