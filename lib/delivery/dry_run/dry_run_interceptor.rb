# encoding:UTF-8

# A mailer interceptor to avoid from actually sending
# the email but rather just log whatever would have happened
class DryRunInterceptor
  def initialize(output = STDOUT)
    @output = output
  end

  def delivering_email(message)
    @output.puts build_header(message)
    @output.puts attachment_data(message) if message.has_attachments?
    @output.puts build_body(message)

    message.perform_deliveries = false
  end

  private

  def build_header(message)
    "I would email from '#{message.from.join(', ')}' to \
'#{message.to.join(', ')}' with subject '#{message.subject}'."
  end

  def build_body(message)
    "The body would be:
#{message.text_part}
The html body would be:
#{message.html_part}"
  end

  def attachment_data(message)
    @output.puts "The email would have #{message.attachments.size} attached \
files(s):"
    attachment_descriptions = message.attachments.map do |attachment|
      "File '#{attachment.filename}' with type #{attachment.content_type}"
    end
    @output.puts attachment_descriptions.join("\n")
  end
end
