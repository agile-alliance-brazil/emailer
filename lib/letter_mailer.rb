# encoding:UTF-8
require 'action_controller'
require 'action_mailer'

# A mailer that sends a mailed_certificate with both HTML and plain text
# representations along with attachments if available.
class LetterMailer < ActionMailer::Base
  def mail_to(letter)
    letter.attachments.each { |a| attachments[a.basename] = a.content }

    mail(header_data(letter)) do |format|
      format.html { render html: letter.html.html_safe }
      format.text { render plain: letter.text }
    end
  end

  private

  def header_data(letter)
    header = {
      to: letter.recipient,
      from: letter.sender,
      subject: letter.subject
    }
    header[:bcc] = letter.bcc if letter.bcc?
    header
  end
end
