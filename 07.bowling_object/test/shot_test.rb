# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/shot'

class ShotTest < Test::Unit::TestCase
  def test_score
    assert_equal(0, Shot.new(0).score)
    assert_equal(5, Shot.new(5).score)
    assert_equal(10, Shot.new('X').score)
  end
end
