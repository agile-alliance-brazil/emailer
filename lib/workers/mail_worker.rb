# encoding: UTF-8
require_relative '../models/letter.rb'
require_relative '../letter_mailer.rb'

# Processes a single mail
class MailWorker
  def initialize(preset_headers, recipient, subject, body, style_injector)
    headers = preset_headers.merge(
      recipient: recipient,
      subject: subject
    )
    @letter = Letter.new(headers, body, style_injector)
  end

  def process
    LetterMailer.mail_to(@letter).deliver_now
  end
end
