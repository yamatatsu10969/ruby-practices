# frozen_string_literal: true

class LongStyle
  def initialize(files)
    @files = files
  end

  def format
    stat_file_hashes = convert_to_stat_file_hashes(@files)
    texts = ["total #{get_total_blocks(stat_file_hashes)}"] +
            get_long_format_texts(get_formatted_stat_files(stat_file_hashes), get_max_lengths(stat_file_hashes))
    texts.map(&:rstrip).join("\n")
  end

  private

  def get_formatted_stat_files(stat_file_hashes = {})
    stat_file_hashes.map do |stat_file_hash|
      stat_file = stat_file_hash[:stat]
      {
        type: get_file_type(stat_file),
        permission: format_permission(stat_file),
        hard_link: stat_file.nlink.to_s,
        user_name: Etc.getpwuid(stat_file.uid).name,
        group_name: Etc.getgrgid(stat_file.gid).name,
        size: stat_file.size.to_s,
        last_modified_time: stat_file.mtime.strftime('%b %d %H:%M'),
        name: get_name_with_symlink(stat_file_hash[:name])
      }
    end
  end

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

  def convert_to_stat_file_hashes(files)
    files.map do |file|
      FileTest.symlink?(file) ? { stat: File.lstat(file), name: file.to_s } : { stat: File.stat(file), name: file.to_s }
    end
  end

  def get_name_with_symlink(file)
    FileTest.symlink?(file) ? "#{file} -> #{File.readlink(file)}" : file.to_s
  end

  def get_total_blocks(stat_file_hashes)
    stat_file_hashes.map { |f| f[:stat] }.sum(&:blocks)
  end

  def get_file_type(file)
    file.ftype == 'file' ? '-' : file.ftype[0]
  end

  def format_permission(stat_file)
    mode = stat_file.mode.to_s(8)
    permission = mode[- 3..]
    file_owner_permission = permission[0].to_i.to_s(2)
    file_group_permission = permission[1].to_i.to_s(2)
    other_permission = permission[2].to_i.to_s(2)
    convert_to_permission_string(file_owner_permission) + convert_to_permission_string(file_group_permission) + convert_to_permission_string(other_permission)
  end

  def convert_to_permission_string(permission)
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
    end.join
  end
end
