# encoding: UTF-8
# Represents an attachment in a letter.
# Simply holds a name and a file data and content type
class Attachment
  attr_reader %i(basename content content_type)
end
