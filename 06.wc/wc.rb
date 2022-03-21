# frozen_string_literal: true

require 'etc'
require 'optparse'

def run_wc
  paths = ARGV
  first_path = paths[0]
  # TODO: 三項演算子に変更
  if first_path.nil?
    # TODO: file ではなく標準入力を処理
  else
    data = p build_wc_data(first_path)
  end
  puts format_wc_data(data)
end

def build_wc_data(file_path)
  readlines = File.readlines(file_path)
  {
    lines: readlines.size,
    words: readlines.sum { |line| line.split(/\s/).size },
    bytes: readlines.sum(&:bytesize),
    name: File.basename(file_path)
  }
end

def format_wc_data(wc_data)
  # TODO: 8以上の桁数にも対応する
  [
    wc_data[:lines].to_s.rjust(8),
    wc_data[:words].to_s.rjust(8),
    wc_data[:bytes].to_s.rjust(8),
    wc_data[:name]
  ].join(' ')
end

run_wc
