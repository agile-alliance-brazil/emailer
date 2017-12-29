#! /usr/bin/env ruby
# encoding: UTF-8
require 'dotenv'
require 'action_controller'
require 'action_mailer'
require_relative 'delivery.rb'
require_relative 'controllers/bulk_mailer.rb'
require_relative 'configuration/mailer_option_parser.rb'
require_relative 'parsers/csv_parser.rb'

def build_smtp_options
  {
    address: ENV['SMTP_SERVER'],
    port: ENV['SMTP_PORT'] || '587',
    domain: ENV['SENDER'] && ENV['SENDER'].split('@').last,
    authentication: ENV['AUTHENTICATION'] || 'plain',
    user_name: ENV['SMTP_USERNAME'] || ENV['SENDER'],
    password: ENV['SMTP_PASSWORD']
  }
end

def build_aws_options
  {
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    server: ENV['AWS_SERVER']
  }
end

def build_deliveries(options)
  {
    sender: ENV['SENDER'],
    dry_run: options[:dry_run],
    smtp: build_smtp_options,
    aws: build_aws_options
  }
end

Dotenv.load
parser = MailerOptionParser.new
config = parser.parse!(ARGV)

config[:delivery] = build_deliveries(config)
delivery = Delivery.configure_deliveries(config[:delivery]).first
delivery.install_on(ActionMailer::Base)

sender = config[:delivery][:sender]
subject_template = config[:subject_template]
body_template = config[:body_template]
data_set = config[:data_set]
css = config[:css]
bcc = config[:bcc]
parser = CSVParser.new(data_set)

mailer = BulkMailer.new(sender, subject_template, body_template, bcc, css)
mailer.process(parser.to_attributes)
