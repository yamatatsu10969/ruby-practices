# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls_practice'
class LsTest < Minitest::Test
  def setup
    @current_dir = Dir.pwd
  end

  def teardown
    Dir.chdir(@current_dir)
  end

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

  def test_ls_with_a_option
    expected = <<~TEXT
      .                       hoge6.txt               hogehogehoge3.txt
      hoge1.txt               hoge7.txt               hogehogehoge4.txt
      hoge10.txt              hoge8.txt               hogehogehoge5.txt
      hoge11.txt              hoge9.txt               hogehogehoge6.txt
      hoge12.txt              hogehogehoge1.txt       hogehogehoge7.txt
      hoge13.txt              hogehogehoge10.txt      hogehogehoge8.txt
      hoge2.txt               hogehogehoge11.txt      hogehogehoge9.txt
      hoge3.txt               hogehogehoge12.txt
      hoge4.txt               hogehogehoge13.txt
      hoge5.txt               hogehogehoge2.txt
    TEXT
    assert_equal(expected.rstrip, LS.new(['a']).create_files_and_folders_text)
  end

  def test_ls_with_r_option
    expected = <<~TEXT
      hogehogehoge9.txt       hogehogehoge12.txt      hoge4.txt
      hogehogehoge8.txt       hogehogehoge11.txt      hoge3.txt
      hogehogehoge7.txt       hogehogehoge10.txt      hoge2.txt
      hogehogehoge6.txt       hogehogehoge1.txt       hoge13.txt
      hogehogehoge5.txt       hoge9.txt               hoge12.txt
      hogehogehoge4.txt       hoge8.txt               hoge11.txt
      hogehogehoge3.txt       hoge7.txt               hoge10.txt
      hogehogehoge2.txt       hoge6.txt               hoge1.txt
      hogehogehoge13.txt      hoge5.txt
    TEXT
    assert_equal(expected.rstrip, LS.new(['r']).create_files_and_folders_text)
  end

  def test_ls_with_l_option
    expected = <<~TEXT
      total 32
      -rwxr-xr-x  1 tatsuyayamamoto  staff     0 Feb 22 01:07 chmod_755_hoge.txt
      -rwxr-xr-x  1 tatsuyayamamoto  staff     0 Feb 22 01:07 chmod_777_hoge.txt
      -rw-r--r--  1 tatsuyayamamoto  staff     4 Feb 22 01:07 hoge_4byte.txt
      -rw-r--r--  1 tatsuyayamamoto  staff  8193 Feb 22 01:07 hoge_8193byte.txt
      drwxr-xr-x  3 tatsuyayamamoto  staff    96 Feb 22 01:07 hoge_directory
      -rw-r--r--  1 tatsuyayamamoto  staff     0 Feb 22 01:07 sudo_hoge.txt
      lrwxr-xr-x  1 tatsuyayamamoto  staff    13 Feb 22 01:07 symlink_hoge -> sudo_hoge.txt
    TEXT
    Dir.chdir('../test_dir_option_l')
    assert_equal(expected.rstrip, LS.new(['l']).create_files_and_folders_text)
  end
end
