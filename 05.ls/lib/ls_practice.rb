# frozen_string_literal: true

require 'optparse'

def main
  options = Option.recognize_options
  puts LS.new(options).create_files_and_folders_text
end

module Option
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

  def show_files_that_begin_with_dot?
    @options.include?('a')
  end

  def reverse_order?
    @options.include?('r')
  end

  def show_long_format?
    @options.include?('l')
  end
end

class LS
  include Option

  MAX_COLUMN_NUMBER = 3
  MAX_COLUMN_NUMBER.freeze

  WHITE_SPACE_INDENT_LENGTH = 6
  WHITE_SPACE_INDENT_LENGTH.freeze

  def initialize(options = [])
    @options = options
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

  def long_format_files_and_folders_text(files)
    stat_files = to_stat_files(files)
    text_array = []
    text_array.push("total #{total_blocks(stat_files)}")
    p permissions(stat_files)
    p file_types(stat_files)
    text_array.map(&:rstrip).join("\n")
    # format("%#{WHITE_SPACE_INDENT_LENGTH}s %s", file, format_file_or_folder_type(file))
  end

  def to_stat_files(files)
    files.map do |file|
      File::Stat.new(file)
    end
  end

  def total_blocks(files)
    files.sum(&:blocks)
  end

  def permissions(files)
    files.map do |file|
      mode = file.mode.to_s(8)
      permission = mode[- 3..]
      file_owner_permission = permission[0].to_i.to_s(2)
      file_group_permission = permission[1].to_i.to_s(2)
      other_permission = permission[2].to_i.to_s(2)
      p file_owner_permission + file_group_permission + other_permission
      p to_permission_string(file_owner_permission) + file_group_permission + other_permission
      # p to_permission_string(file_owner_permission)
    end
  end

  def to_permission_string(permission)
    text = permission.split('').map.each_with_index do |string, index|
      if string == '0'
        '-'
      elsif index.zero?
        'r'
      elsif index == 1
        'w'
      else
        'x'
      end
    end.join('')
    p text
  end

  def file_types(files)
    files.map do |file|
      if file.ftype == 'file'
        '-'
      else
        file.ftype[0]
      end
    end
  end
end

main
