# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/frame'

class FrameTest < Test::Unit::TestCase
  sub_test_case '#strike?' do
    test '文字列"X"のみを渡したら true を返す' do
      assert(Frame.new('X').strike?)
    end
    test '文字列"X"のみではない時は false を返す' do
      assert_false(Frame.new('1', '2').strike?)
      assert_false(Frame.new('0', '10').strike?)
    end
  end

  sub_test_case '#spare?' do
    test '合計が10になる時 true を返す' do
      assert(Frame.new('2', '8').spare?)
      assert(Frame.new('0', '10').spare?)
    end
    test '合計が10にならない時 false を返す' do
      assert_false(Frame.new('1', '2').spare?)
    end
    test 'strike の時は false を返す' do
      assert_false(Frame.new('X').spare?)
    end
  end

  sub_test_case '#total' do
    test '文字列"X"を10にして、合計を返す' do
      assert_equal(25, Frame.new('X', 'X', '5').score)
      assert_equal(10, Frame.new('X').score)
    end
    test '合計を返す' do
      assert_equal(8, Frame.new('6', '2').score)
      assert_equal(9, Frame.new('9', '0').score)
    end
  end
end
