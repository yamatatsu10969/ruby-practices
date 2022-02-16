# frozen_string_literal: true

require 'optparse'

def main
  options = LS.recognize_options
  puts LS.new(options).create_files_and_folders_text
end

class LS
  MAX_COLUMN_NUMBER = 3
  MAX_COLUMN_NUMBER.freeze

  WHITE_SPACE_INDENT_LENGTH = 6
  WHITE_SPACE_INDENT_LENGTH.freeze

  def initialize(options = [])
    @options = options
  end

  def self.recognize_options
    options = []
    OptionParser.new do |opt|
      opt.on('-a') { |_| options.push('a') }
      opt.parse!(ARGV)
    end
    options
  end

  def create_files_and_folders_text
    files = files_and_folders
    column_item_number = files.size / MAX_COLUMN_NUMBER

    max_text_length = files.map(&:length).max + WHITE_SPACE_INDENT_LENGTH

    text_array = []

    (0..column_item_number).each do |column_index|
      text = ''
      (0..(MAX_COLUMN_NUMBER - 1)).map do |row_index|
        file_index = column_index + row_index + (row_index * column_item_number)
        text += format("%-#{max_text_length}s", files[file_index])
      end
      text_array.push(text)
    end
    text_array.map(&:rstrip).join("\n")
  end

  def files_and_folders
    if show_files_that_begin_with_dot?
      Dir.glob('*', File::FNM_DOTMATCH)
    else
      Dir.glob('*')
    end
  end

  def show_files_that_begin_with_dot?
    @options.include?('a')
  end
end

main
