# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/frame'

class FrameTest < Test::Unit::TestCase
  def test_strike?
    assert(Frame.new('X').strike?)
    assert_false(Frame.new('1', '2').strike?)
  end

  def test_spare?
    assert(Frame.new('2', '8').spare?)
    assert(Frame.new('0', 'X').spare?)
    assert_false(Frame.new('X').spare?)
    assert_false(Frame.new('1', '2').spare?)
  end

  def test_score
    assert_equal(10, Frame.new('X').score)
    assert_equal(8, Frame.new('6', '2').score)
    assert_equal(9, Frame.new('9', '0').score)
    assert_equal(25, Frame.new('X', 'X', '5').score)
  end
end
