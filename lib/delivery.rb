# encoding:UTF-8
require_relative 'delivery/dry_run.rb'
require_relative 'delivery/smtp.rb'
require_relative 'delivery/aws.rb'

# Represents available delivery options to send certificate.
# Can be a dry-run (delivers to terminal), an AWS SES delivery
# or an SMTP delivery
module Delivery
  def self.configure_deliveries(config)
    deliveries = []
    deliveries << Delivery::DryRun.new if config[:dry_run]
    deliveries << build_aws(config[:aws]) if config[:aws]
    deliveries << Delivery::SMTP.new(config[:smtp])

    deliveries.select(&:complete?)
  end

  private_class_method

  def self.build_aws(config)
    Delivery::AWS.new(
      config[:access_key_id],
      config[:secret_access_key],
      config[:server]
    )
  end
end
