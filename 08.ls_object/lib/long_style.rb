# frozen_string_literal: true

require_relative './files_converter'

class LongStyle
  def initialize(files)
    @files = files
  end

  def format
    files_converter = FilesConverter.new(@files)
    stat_file_hashes = files_converter.to_stat_file_hashes
    formatted_stat_files = files_converter.to_formatted_stat_files
    texts = ["total #{get_total_blocks(stat_file_hashes)}"] +
            get_long_format_texts(formatted_stat_files, get_max_lengths(stat_file_hashes))
    texts.map(&:rstrip).join("\n")
  end

  private

  def get_max_lengths(stat_file_hashes)
    max_lengths = { hard_link: 0, user_name: 0, group_name: 0, size: 0 }
    stat_files = stat_file_hashes.map { |stat_file_hash| stat_file_hash[:stat] }
    max_lengths[:hard_link] = stat_files.map(&:nlink).map(&:to_s).map(&:length).max
    max_lengths[:user_name] = stat_files.map { |stat_file| Etc.getpwuid(stat_file.uid).name }.map(&:length).max
    max_lengths[:group_name] = stat_files.map { |stat_file| Etc.getgrgid(stat_file.gid).name }.map(&:length).max
    max_lengths[:size] = stat_files.map(&:size).map(&:to_s).map(&:length).max
    max_lengths
  end

  def get_long_format_texts(formatted_stat_files, max_length)
    formatted_stat_files.map do |stat_file|
      format_long_text(stat_file, max_length)
    end
  end

  def format_long_text(stat_file, max_length)
    single_white_spaces = ' '
    two_white_spaces = '  '
    [
      stat_file[:type] + stat_file[:permission],
      two_white_spaces,
      stat_file[:hard_link].rjust(max_length[:hard_link]),
      single_white_spaces,
      stat_file[:user_name].ljust(max_length[:user_name]),
      two_white_spaces,
      stat_file[:group_name].ljust(max_length[:group_name]),
      two_white_spaces,
      stat_file[:size].rjust(max_length[:size]),
      single_white_spaces,
      stat_file[:last_modified_time],
      single_white_spaces,
      stat_file[:name]
    ].join
  end

  def get_total_blocks(stat_file_hashes)
    stat_file_hashes.map { |f| f[:stat] }.sum(&:blocks)
  end
end
