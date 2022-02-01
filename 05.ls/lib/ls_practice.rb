# frozen_string_literal: true

def main
  puts LS.new.show
end

class LS
  MAX_COLUMN_LENGTH = 3
  MAX_COLUMN_LENGTH.freeze

  WHITE_SPACE_INDENT_LENGTH = 6
  WHITE_SPACE_INDENT_LENGTH.freeze

  def show
    files = Dir.glob('*')
    column_item_length = files.length / MAX_COLUMN_LENGTH

    max_text_length = files.map(&:length).max + WHITE_SPACE_INDENT_LENGTH

    text = %()

    (0..column_item_length).each do |n|
      (0..(MAX_COLUMN_LENGTH - 1)).map do |i|
        index = n + i + (i * column_item_length)
        if (MAX_COLUMN_LENGTH - 1) == i
          text += files[index].to_s
          text += "\n"
        else
          text += format("%-#{max_text_length}s", files[index])
        end
      end
    end
    text
  end
end

main
