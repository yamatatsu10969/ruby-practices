# frozen_string_literal: true

require 'optparse'
require 'etc'

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

module PermissionFormat
  def permissions(stat_files)
    stat_files.map do |file|
      mode = file.mode.to_s(8)
      permission = mode[- 3..]
      file_owner_permission = permission[0].to_i.to_s(2)
      file_group_permission = permission[1].to_i.to_s(2)
      other_permission = permission[2].to_i.to_s(2)
      to_permission_string(file_owner_permission) + to_permission_string(file_group_permission) + to_permission_string(other_permission)
    end
  end

  def to_permission_string(permission)
    permission.split('').map.each_with_index do |string, index|
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
  end
end

module LongFormat
  include PermissionFormat
  def long_format_files_and_folders_text(files)
    stat_files = to_stat_files(files)
    text_array = to_file_information_array(stat_files, files)
    text_array.map(&:rstrip).join("\n")
  end

  def to_file_information_array(stat_files, files)
    permissions = permissions(stat_files)
    file_types = file_types(stat_files)
    hard_link_numbers = hard_link_numbers(stat_files)
    user_names = user_names(stat_files)
    group_names = group_names(stat_files)
    file_sizes = file_sizes(stat_files)
    last_update_date_times = last_update_date_times(stat_files)
    names_and_symlink_names = names_and_symlink_names(files)
    text_array = ["total #{total_blocks(stat_files)}"]
    permissions.size.times do |index|
      text = "#{file_types[index]}#{permissions[index]}  "
      text += "#{hard_link_numbers[index].to_s.rjust(hard_link_numbers.map(&:to_s).map(&:length).max)} "
      text += "#{user_names[index].ljust(user_names.map(&:length).max)}  "
      text += "#{group_names[index].ljust(group_names.map(&:length).max)}  "
      text += "#{file_sizes[index].to_s.rjust(file_sizes.map(&:to_s).map(&:length).max)} "
      text += "#{last_update_date_times[index].ljust(last_update_date_times.map(&:length).max)} "
      text += names_and_symlink_names[index]
      text_array.push(text)
    end
    text_array
  end

  def to_stat_files(stat_files)
    stat_files.map do |file|
      if FileTest.symlink?(file)
        File.lstat(file)
      else
        File.stat(file)
      end
    end
  end

  def names_and_symlink_names(files)
    files.map do |file|
      if FileTest.symlink?(file)
        "#{file} -> #{File.readlink(file)}"
      else
        file.to_s
      end
    end
  end

  def total_blocks(stat_files)
    stat_files.sum(&:blocks)
  end

  def hard_link_numbers(stat_files)
    stat_files.map(&:nlink)
  end

  def user_names(stat_files)
    stat_files.map do |file|
      Etc.getpwuid(file.uid).name
    end
  end

  def file_sizes(stat_files)
    stat_files.map(&:size)
  end

  def group_names(stat_files)
    stat_files.map do |file|
      Etc.getgrgid(file.gid).name
    end
  end

  def last_update_date_times(stat_files)
    stat_files.map do |file|
      file.mtime.strftime('%b %d %H:%M')
    end
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

class LS
  include Option
  include LongFormat

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
end

main
