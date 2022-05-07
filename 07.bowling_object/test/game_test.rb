# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/game'

class GameTest < Test::Unit::TestCase
  sub_test_case '#score' do
    test 'パターン1' do
      assert_equal(139, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5').score)
    end
    test 'パターン2' do
      assert_equal(164, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X').score)
    end
    test 'パターン3' do
      assert_equal(107, Game.new('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4').score)
    end
    test 'パターン4' do
      assert_equal(134, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0').score)
    end
    test 'パターン5' do
      assert_equal(144, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8').score)
    end
    test 'パターン6' do
      assert_equal(300, Game.new('X,X,X,X,X,X,X,X,X,X,X,X').score)
    end
  end
end
