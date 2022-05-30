# frozen_string_literal: true

require 'optparse'
require 'etc'

require_relative 'list_directory_contents'

def main
  options = []
  OptionParser.new do |opt|
    opt.on('-a') { |_| options.push('a') }
    opt.on('-r') { |_| options.push('r') }
    opt.on('-l') { |_| options.push('l') }
    opt.parse!(ARGV)
  end
  ListDirectoryContents.new(options).display
end

main
