# frozen_string_literal: true

require 'etc'
require 'optparse'

DEFAULT_MAX_LENGTH = 8

def run_wc
  paths = ARGV
  is_only_lines = OptionParser.getopts('l')['l']
  if paths.empty?
    format_from_standard_input(is_only_lines)
  elsif paths.size == 1
    format_from_path(paths[0], is_only_lines)
  else
    format_from_paths(paths, is_only_lines)
  end
end

def format_from_standard_input(is_only_lines)
  wc_item = build_wc_item($stdin.readlines)
  max_lengths = build_max_lengths(wc_item)
  format_wc_item(wc_item, max_lengths, is_only_lines)
end

def format_from_path(path, is_only_lines)
  wc_item = build_wc_item(File.readlines(path), path)
  max_lengths = build_max_lengths(wc_item)
  format_wc_item(wc_item, max_lengths, is_only_lines)
end

def format_from_paths(paths, is_only_lines)
  wc_items = paths.map { |path| build_wc_item(File.readlines(path), path) }
  total_wc_item = build_total_wc_item(wc_items)
  # total の数が一番大きくなるため、total を元にmax_lengths を求める
  max_lengths = build_max_lengths(total_wc_item)
  wc_items << total_wc_item
  formatted_wc_items = wc_items.map { |wc_item| format_wc_item(wc_item, max_lengths, is_only_lines) }
  formatted_wc_items.join("\n")
end

def build_total_wc_item(wc_items)
  {
    lines: wc_items.sum { |wc_item| wc_item[:lines] },
    words: wc_items.sum { |wc_item| wc_item[:words] },
    bytes: wc_items.sum { |wc_item| wc_item[:bytes] },
    file: 'total'
  }
end

def build_wc_item(readlines, file_path = nil)
  {
    lines: readlines.size,
    words: readlines.sum { |line| line.split(/\s/).size },
    bytes: readlines.sum(&:bytesize),
    file: file_path.nil? ? nil : File.basename(file_path)
  }
end

def format_wc_item(wc_item, max_lengths, is_only_lines)
  [
    wc_item[:lines].to_s.rjust(max_lengths[:lines]),
    is_only_lines ? '' : wc_item[:words].to_s.rjust(max_lengths[:words]),
    is_only_lines ? '' : wc_item[:bytes].to_s.rjust(max_lengths[:bytes]),
    ' ',
    wc_item[:file].nil? ? '' : wc_item[:file]
  ].join.rstrip
end

def build_max_lengths(wc_item)
  {
    lines: [DEFAULT_MAX_LENGTH, wc_item[:lines].to_s.size].max,
    words: [DEFAULT_MAX_LENGTH, wc_item[:words].to_s.size].max,
    bytes: [DEFAULT_MAX_LENGTH, wc_item[:bytes].to_s.size].max
  }
end

puts run_wc
