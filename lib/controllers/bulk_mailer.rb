# encoding: UTF-8
require 'ostruct'
require_relative '../parsers/erb_parser.rb'
require_relative '../workers/mail_worker.rb'
require_relative '../decorators/css_injector.rb'

# Bulk mailer. Associates a common sender, bcc, subject and body template to a
# bulk of recipients defined in a csv with bindings for the body template.
class BulkMailer
  def initialize(sender, subject, body_template, bcc = nil, css = '')
    @sender = sender
    @subject_parser = ErbParser.new(subject)
    @body_parser = ErbParser.new(body_template)
    @bcc = bcc
    @style_injector = CssInjector.new(css)
  end

  def process(data_set)
    data_set.each do |data|
      namespace = OpenStruct.new(data)
      subject = @subject_parser.parse_using(namespace)
      body = @body_parser.parse_using(namespace)
      worker = MailWorker.new(headers, namespace.email, subject, body,
                              @style_injector)
      worker.process
    end
  end

  private

  def headers
    return @headers if @headers

    @headers = {
      sender: @sender
    }
    @headers[:bcc] = @bcc if @bcc
    @headers
  end
end
