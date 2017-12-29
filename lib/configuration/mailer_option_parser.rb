# encoding:UTF-8
require 'optparse'
require_relative '../version.rb'
require_relative 'configuration_error.rb'

# The parser for mailer options. Describes all options and how
# to parse them for the application
class MailerOptionParser
  def initialize
    @dry_run = false
    @parser = OptionParser.new(&options_block)
  end

  def parse!(arguments)
    raise ConfigurationError, arguments_error(arguments) if invalid?(arguments)

    @parser.parse!(arguments)

    build_config(arguments)
  end

  def help
    @parser.help
  end

  private

  def build_config(arguments)
    params = {
      subject_template: arguments[0],
      body_template: read(arguments[1]),
      data_set: read(arguments[2]),
      dry_run: @dry_run,
      bcc: @bcc
    }
    params[:css] = read(arguments[3]) if arguments.size > 3
    params
  end

  def read(path)
    File.read(path)
  end

  def invalid?(arguments)
    not_enough_arguments(arguments) ||
      invalid_body_template?(arguments[1]) ||
      invalid_data_set?(arguments[2])
  end

  def arguments_error(arguments)
    specific_error = error_for(arguments)
    %(#{specific_error}\n\n#{@parser.help})
  end

  def not_enough_arguments(arguments)
    arguments.reject { |a| a.start_with?('--') }.size < 3
  end

  def invalid_body_template?(template_path)
    !File.exist?(template_path) || !File.readable?(template_path)
  end

  def invalid_data_set?(data_path)
    !File.exist?(data_path) || !File.readable?(data_path)
  end

  def error_for(arguments)
    if not_enough_arguments(arguments)
      return "Invalid number of arguments. Expected at least 3, got \
#{arguments.size}."
    end

    body = arguments[1]
    return 'Body template file is not readable' if invalid_body_template?(body)

    data = arguments[2]
    return 'Data set file is not readable' if invalid_data_set?(data)
  end

  def options_block
    lambda do |opts|
      opts.banner = banner_message
      opts.separator ''
      specific_options(opts)
      opts.separator ''
      common_options(opts)
    end
  end

  def specific_options(opts)
    opts.separator 'Specific options:'
    opts.on('--dry-run', dry_run_message) { @dry_run = true }
    opts.on('--bcc', bcc_message) { |value| @bcc = value }
  end

  def banner_message
    %(Usage: bundle exec ruby #{$PROGRAM_NAME} subject body_template.md \
data.csv [styles.css] [options]

#{argument_description})
  end

  def argument_description
    %(\tsubject -- A single string that will be ERB'd against the data \
provided in 'data.csv'.
\tbody_template.md -- The path to a markdown file that will be ERB'd against \
the data provided in 'data.csv' to generate both an HTML and text email body.
\tdata.csv -- The path to a CSV file (comma separated, one data set per row, \
with header) that will be used as the environment to the generate the body \
and the subject. It must contain at least one column with a header called \
'email'.
\tstyles.css -- Optional. The path to a CSS file that will be injected in the \
html version of the email.)
  end

  def common_options(opts)
    opts.separator 'Common options:'

    opts.on_tail('-h', '--help', '--usage', 'Show this message and quit.') do
      puts(opts.help) && exit
    end

    opts.on_tail('-v', '--version', 'Show current version') do
      puts(Mailer::VERSION::STRING) && exit
    end
  end

  def dry_run_message
    "Generate email but don't send them. Just log them to STDOUT."
  end

  def bcc_message
    "If you desire every email sent be bcc'ed to another email, specify the \
address here. Must be a valid email address or will be ignored."
  end
end
