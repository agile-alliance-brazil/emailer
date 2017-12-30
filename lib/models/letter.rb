# encoding: UTF-8
require 'redcarpet'
require_relative '../decorators/color_remover.rb'

# Represents a letter to be sent
class Letter
  attr_reader :recipient, :sender, :bcc, :subject

  def initialize(headers, body, style_injector, *attachments)
    @recipient = headers[:recipient]
    @sender = headers[:sender]
    @bcc = Array(headers[:bcc])
    @subject = headers[:subject]
    @body = body
    @style_injector = style_injector
    @attachments = attachments || []
    options = { autolink: true, no_intra_emphasis: true, tables: true }
    @html_renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML, options)
  end

  def attachments
    @attachments || []
  end

  def bcc?
    !@bcc.empty?
  end

  def html
    @style_injector.decorate(@html_renderer.render(@body))
  end

  def text
    color_remover.decorate(@body)
  end

  private

  def color_remover
    @color_remover ||= ColorRemover.new
  end
end
