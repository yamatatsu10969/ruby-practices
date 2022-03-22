# frozen_string_literal: true

require 'etc'
require 'optparse'

DEFAULT_MAX_LENGTH = 8

def run_wc
  paths = ARGV
  paths.empty? ? format_from_standard_input : format_from_paths(paths)
end

def format_from_standard_input
  wc_item = build_wc_item(STDIN.readlines)
  max_lengths = build_max_lengths([wc_item])
  format_wc_item(wc_item, max_lengths)
end

def format_from_paths(paths)
  wc_items = paths.map { |path| build_wc_item(File.readlines(path), path) }
  max_lengths = build_max_lengths(wc_items)
  formatted_wc_items = wc_items.map { |wc_item| format_wc_item(wc_item, max_lengths) }
  body = formatted_wc_items.join("\n")

  if paths.size == 1
    body
  else
    footer = format_total_wc_item(build_total_wc_item(wc_items))
    [body, footer].join("\n")
  end
end

def format_total_wc_item(wc_item)
  format_wc_item(wc_item, build_max_lengths([wc_item]))
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

def format_wc_item(wc_item, max_lengths)
  [
    wc_item[:lines].to_s.rjust(max_lengths[:lines]),
    wc_item[:words].to_s.rjust(max_lengths[:words]),
    wc_item[:bytes].to_s.rjust(max_lengths[:bytes]),
    ' ',
    wc_item[:file].nil? ? '' : wc_item[:file]
  ].join.rstrip
end

def build_max_lengths(wc_items)
  max_lengths = {
    lines: DEFAULT_MAX_LENGTH,
    words: DEFAULT_MAX_LENGTH,
    bytes: DEFAULT_MAX_LENGTH
  }
  wc_items.each do |wc_item|
    max_lengths[:lines] = [max_lengths[:lines], wc_item[:lines].to_s.size].max
    max_lengths[:words] = [max_lengths[:words], wc_item[:words].to_s.size].max
    max_lengths[:bytes] = [max_lengths[:bytes], wc_item[:bytes].to_s.size].max
  end
  max_lengths
end

puts run_wc
