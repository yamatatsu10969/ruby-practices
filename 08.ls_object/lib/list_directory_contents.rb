# frozen_string_literal: true

require_relative 'long_style'
require_relative 'short_style'

class ListDirectoryContents
  def initialize(options = [])
    @options = options
  end

  def display
    puts create_files_and_folders_text
  end

  private

  def show_files_with_dot?
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
    show_long_format? ? LongStyle.new(files).format : ShortStyle.new(files).format
  end

  def files_and_folders
    show_files_with_dot? ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  end
end
