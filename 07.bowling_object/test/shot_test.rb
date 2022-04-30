# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/shot'

class ShotTest < Test::Unit::TestCase
  sub_test_case '#score' do
    test '文字列"X"を10にする' do
      assert_equal(10, Shot.new('X').score)
    end

    test '"X"以外はそのまま数字を返す' do
      assert_equal(0, Shot.new(0).score)
      assert_equal(5, Shot.new(5).score)
    end
  end
end
