# encoding:UTF-8
require 'csv'

# Handles parsing CSV.
# Transforms each row in an attribute map where the keys are
# the CSV header names and the values are the entries in each row
class CSVParser
  def initialize(content)
    @csv = CSV.parse(content)
    @headers = @csv.shift
  end

  def to_attributes
    @csv.map do |row|
      attribute_pairs = @headers.map.with_index do |h, idx|
        [h, row[idx]]
      end
      Hash[attribute_pairs]
    end
  end
end
