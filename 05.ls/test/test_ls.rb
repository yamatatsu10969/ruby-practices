# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls_practice'
class LsTest < Minitest::Test
  def test_ls_without_option
    expected = <<~TEXT
      hoge1.txt               hoge6.txt               hogehogehoge2.txt
      hoge10.txt              hoge7.txt               hogehogehoge3.txt
      hoge11.txt              hoge8.txt               hogehogehoge4.txt
      hoge12.txt              hoge9.txt               hogehogehoge5.txt
      hoge13.txt              hogehogehoge1.txt       hogehogehoge6.txt
      hoge2.txt               hogehogehoge10.txt      hogehogehoge7.txt
      hoge3.txt               hogehogehoge11.txt      hogehogehoge8.txt
      hoge4.txt               hogehogehoge12.txt      hogehogehoge9.txt
      hoge5.txt               hogehogehoge13.txt
    TEXT
    assert_equal(expected.rstrip, LS.new.create_files_and_folders_text)
  end
end
