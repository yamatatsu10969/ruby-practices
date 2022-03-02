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
end

module PermissionFormat
  def format_permission(stat_file)
    mode = stat_file.mode.to_s(8)
    permission = mode[- 3..]
    file_owner_permission = permission[0].to_i.to_s(2)
    file_group_permission = permission[1].to_i.to_s(2)
    other_permission = permission[2].to_i.to_s(2)
    to_permission_string(file_owner_permission) + to_permission_string(file_group_permission) + to_permission_string(other_permission)
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
  def long_format_text(files)
    stat_files = convert_to_stat_files(files)
    file_info_hash = file_info_hash(stat_files, files)
    text_array = ["total #{total_blocks(stat_files)}"] +
                 file_info_array(file_info_hash[:file_info_hash_array], file_info_hash[:max_length_hash])
    text_array.map(&:rstrip).join("\n")
  end

  def file_info_hash(stat_files, files)
    # 1度のループで最大長を取得する
    max_length_hash = { hard_link: 0, user_name: 0, group_name: 0, size: 0 }
    file_info_hash_array = stat_files.map.with_index do |stat_file, index|
      hard_link = stat_file.nlink.to_s
      max_length_hash[:hard_link] = hard_link.length if hard_link.length > max_length_hash[:hard_link]
      user_name = Etc.getpwuid(stat_file.uid).name
      max_length_hash[:user_name] = user_name.length if user_name.length > max_length_hash[:user_name]
      group_name = Etc.getgrgid(stat_file.gid).name
      max_length_hash[:group_name] = group_name.length if group_name.length > max_length_hash[:group_name]
      size = stat_file.size.to_s
      max_length_hash[:size] = size.length if size.length > max_length_hash[:size]
      { type: file_type(stat_file),
        permission: format_permission(stat_file),
        hard_link: hard_link,
        user_name: user_name,
        group_name: group_name,
        size: size,
        last_modified_time: stat_file.mtime.strftime('%b %d %H:%M'),
        name: name_with_symlink(files[index]) }
    end
    { max_length_hash: max_length_hash, file_info_hash_array: file_info_hash_array }
  end

  def file_info_array(file_info_hash_array, max_length_hash)
    file_info_hash_array.map do |file_info|
      format_file_info(file_info, max_length_hash)
    end
  end

  def format_file_info(file_info_hash, max_length_hash)
    two_indent_array = []
    two_indent_array << (file_info_hash[:type] + file_info_hash[:permission])
    two_indent_array << [file_info_hash[:hard_link].to_s.rjust(max_length_hash[:hard_link]),
                         file_info_hash[:user_name].ljust(max_length_hash[:user_name])].join(' ')
    two_indent_array << file_info_hash[:group_name].ljust(max_length_hash[:group_name])
    two_indent_array << [
      file_info_hash[:size].rjust(max_length_hash[:size]),
      file_info_hash[:last_modified_time],
      file_info_hash[:name]
    ].join(' ')
    two_indent_array.join('  ')
  end

  def convert_to_stat_files(files)
    files.map do |file|
      if FileTest.symlink?(file)
        File.lstat(file)
      else
        File.stat(file)
      end
    end
  end

  def name_with_symlink(file)
    if FileTest.symlink?(file)
      "#{file} -> #{File.readlink(file)}"
    else
      file.to_s
    end
  end

  def total_blocks(stat_files)
    stat_files.sum(&:blocks)
  end

  def file_type(file)
    if file.ftype == 'file'
      '-'
    else
      file.ftype[0]
    end
  end
end

module ShortFormat
  MAX_COLUMN_NUMBER = 3
  MAX_COLUMN_NUMBER.freeze

  WHITE_SPACE_INDENT_LENGTH = 6
  WHITE_SPACE_INDENT_LENGTH.freeze

  def short_format_files_and_folders_text(files)
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

class LS
  include Option
  include LongFormat
  include ShortFormat

  def initialize(options = [])
    @options = options
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

  def create_files_and_folders_text
    files = files_and_folders
    files = files.reverse if reverse_order?
    show_long_format? ? long_format_text(files) : short_format_files_and_folders_text(files)
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
