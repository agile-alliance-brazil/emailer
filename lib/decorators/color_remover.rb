# encoding: UTF-8
# Remover color style markups from content and replaces them with spaces
class ColorRemover
  def decorate(content)
    content.gsub(
      %r{<span style='color:#[A-F0-9]{6}'>([^<]*)</span>},
      '                                   \1'
    )
  end
end
