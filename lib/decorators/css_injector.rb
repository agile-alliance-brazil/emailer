# encoding: UTF-8
# CSS injector that takes a CSS definition and inlines it into an HTML content
class CssInjector
  def initialize(css)
    @styles = parse(css)
  end

  def decorate(content)
    @styles.reduce(content) do |decorated_content, (tag, style)|
      decorated_content.gsub(/<#{tag}(?!\w)/, "<#{tag} style='#{style}'")
    end
  end

  private

  def parse(css)
    entries = css.scan(/[a-zA-Z\s,0-9]+\s*\{[^\}]+\}/)
    entries.each_with_object({}) do |entry, styles|
      partial_styles = parse_entry(entry)
      partial_styles.each do |tag, content|
        styles[tag] ||= ''
        styles[tag] = styles[tag] + content
      end
      styles
    end
  end

  def parse_entry(entry)
    match = entry.match(/^([a-zA-Z\s,0-9]+)\s*\{([^\}]+)\}/)
    tags_to_apply = match[1]
    content = match[2].gsub(/\s*\n\s*/, '').gsub(/:\s*/, ':')
    tags = tags_to_apply.split(',').map(&:strip)
    styles = tags.map { |tag| [tag, content] }
    Hash[styles]
  end
end
