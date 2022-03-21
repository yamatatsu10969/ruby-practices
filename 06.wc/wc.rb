# frozen_string_literal: true

require 'etc'
require 'optparse'

DEFAULT_MAX_LENGTH = 8

def run_wc
  paths = ARGV
  if paths.empty?
    # TODO: file ではなく標準入力を処理
  else
    wc_items = paths.map { |path| build_wc_item_from(file_path: path) }
    max_lengths = build_max_lengths(wc_items)
    formatted_wc_items = wc_items.map { |wc_item| format_wc_item(wc_item, max_lengths) }
  end
end

def build_wc_item_from(file_path:)
  readlines = File.readlines(file_path)
  {
    lines: readlines.size,
    words: readlines.sum { |line| line.split(/\s/).size },
    bytes: readlines.sum(&:bytesize),
    name: File.basename(file_path)
  }
end

def format_wc_item(wc_item, max_lengths)
  [
    wc_item[:lines].to_s.rjust(max_lengths[:lines]),
    wc_item[:words].to_s.rjust(max_lengths[:words]),
    wc_item[:bytes].to_s.rjust(max_lengths[:bytes]),
    wc_item[:name]
  ].join(' ')
end

def build_max_lengths(wc_items)
  {
    lines: get_max_length(wc_items, :lines),
    words: get_max_length(wc_items, :words),
    bytes: get_max_length(wc_items, :bytes)
  }
end

def get_max_length(wc_items, key)
  [DEFAULT_MAX_LENGTH, find_max_length(wc_items, key)].max
end

def find_max_length(wc_items, key)
  wc_items.map { |wc_item| wc_item[key].to_s.size }.max
end

run_wc
