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
      opt.on('-r') { |_| options.push('r') }
      opt.on('-l') { |_| options.push('l') }
      opt.parse!(ARGV)
    end
    options
  end

  def create_files_and_folders_text
    files = files_and_folders
    files = files.reverse if reverse_order?

    if show_long_format?
      long_format_files_and_folders_text(files)
    else
      text_array = []
      column_item_number = files.size / MAX_COLUMN_NUMBER
      max_text_length = files.map(&:length).max + WHITE_SPACE_INDENT_LENGTH
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

  def reverse_order?
    @options.include?('r')
  end

  def show_long_format?
    @options.include?('l')
  end

  def long_format_files_and_folders_text(files)
    p "total #{total_blocks(files)}"
    files.map(&:rstrip).join("\n")
    # format("%#{WHITE_SPACE_INDENT_LENGTH}s %s", file, format_file_or_folder_type(file))
  end

  def total_blocks(files)
    files.sum do |file|
      File::Stat.new(file).blocks
    end
  end
end

main
