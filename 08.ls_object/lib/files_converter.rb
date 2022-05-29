# frozen_string_literal: true

require_relative './permission_style'

class FilesConverter
  def initialize(files)
    @files = files
  end

  def to_stat_file_hashes
    @files.map do |file|
      FileTest.symlink?(file) ? { stat: File.lstat(file), name: file.to_s } : { stat: File.stat(file), name: file.to_s }
    end
  end

  def to_formatted_stat_files
    to_stat_file_hashes.map do |stat_file_hash|
      stat_file = stat_file_hash[:stat]
      {
        type: get_file_type(stat_file),
        permission: PermissionStyle.new(stat_file).format,
        hard_link: stat_file.nlink.to_s,
        user_name: Etc.getpwuid(stat_file.uid).name,
        group_name: Etc.getgrgid(stat_file.gid).name,
        size: stat_file.size.to_s,
        last_modified_time: stat_file.mtime.strftime('%b %d %H:%M'),
        name: get_name_with_symlink(stat_file_hash[:name])
      }
    end
  end

  private

  def get_name_with_symlink(file)
    FileTest.symlink?(file) ? "#{file} -> #{File.readlink(file)}" : file.to_s
  end

  def get_file_type(file)
    file.ftype == 'file' ? '-' : file.ftype[0]
  end
end
