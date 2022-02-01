# frozen_string_literal: true

def main
  puts LS.new.show
end

class LS
  MAX_ROW_LENGTH = 3
  MAX_ROW_LENGTH.freeze

  WHITE_SPACE_INDENT_LENGTH = 6
  WHITE_SPACE_INDENT_LENGTH.freeze

  def show
    files = Dir.glob('*')
    row_item_length = files.length / MAX_ROW_LENGTH

    max_text_length = files.map(&:length).max + WHITE_SPACE_INDENT_LENGTH

    text = %()

    (0..row_item_length).each do |n|
      (0..(MAX_ROW_LENGTH - 1)).map do |i|
        index = n + i + (i * row_item_length)
        if (MAX_ROW_LENGTH - 1) == i
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
