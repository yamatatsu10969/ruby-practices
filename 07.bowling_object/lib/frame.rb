# frozen_string_literal: true

require_relative '../lib/shot'

class Frame
  attr_reader :first_shot, :second_shot

  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark) if second_mark
    @third_shot = Shot.new(third_mark) if third_mark
  end

  def score
    score = @first_shot.score
    score += @second_shot.score if @second_shot
    score += @third_shot.score if @third_shot
    score
  end

  def strike?
    return false if @second_shot || @third_shot

    @first_shot.score == 10
  end

  def spare?
    return false if strike? || @third_shot

    @first_shot.score + @second_shot.score == 10
  end
end
