# frozen_string_literal: true

def main
  puts LS.new.create_files_and_folders_text
end

class LS
  MAX_COLUMN_NUMBER = 3
  MAX_COLUMN_NUMBER.freeze

  WHITE_SPACE_INDENT_LENGTH = 6
  WHITE_SPACE_INDENT_LENGTH.freeze

  def create_files_and_folders_text
    files = Dir.glob('*')
    column_item_number = files.size / MAX_COLUMN_NUMBER

    max_text_length = files.map(&:length).max + WHITE_SPACE_INDENT_LENGTH

    text_array = []

    (0..column_item_number).each do |column_index|
      text = %()
      (0..(MAX_COLUMN_NUMBER - 1)).map do |row_index|
        file_index = column_index + row_index + (row_index * column_item_number)
        text += format("%-#{max_text_length}s", files[file_index])
      end
      text_array.push(text)
      puts text
    end
    text_array.map(&:rstrip).join("\n")
  end
end

main
