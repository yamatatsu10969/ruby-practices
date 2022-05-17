# frozen_string_literal: true

class ShortStyle
  MAX_COLUMN_NUMBER = 3
  MAX_COLUMN_NUMBER.freeze

  WHITE_SPACE_INDENT_LENGTH = 6
  WHITE_SPACE_INDENT_LENGTH.freeze

  def initialize(files)
    @files = files
  end

  def format
    formatted_texts = []
    column_item_number = @files.size / MAX_COLUMN_NUMBER
    max_text_length = @files.map(&:length).max + WHITE_SPACE_INDENT_LENGTH
    (0..column_item_number).each do |column_index|
      text = ''
      (0..(MAX_COLUMN_NUMBER - 1)).map do |row_index|
        file_index = column_index + row_index + (row_index * column_item_number)
        text += Kernel.format("%-#{max_text_length}s", @files[file_index])
      end
      formatted_texts.push(text)
    end
    formatted_texts.map(&:rstrip).join("\n")
  end
end
