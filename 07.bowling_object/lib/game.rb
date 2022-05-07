# frozen_string_literal: true

require_relative '../lib/frame'

class Game
  def initialize(text_marks)
    @frames = create_frames(text_marks)
  end

  def score
    score = 0
    @frames.each_with_index do |frame, index|
      score += frame.score
      break if index == 9

      score += strike_bonus(index) if frame.strike?
      score += spare_bonus(index) if frame.spare?
    end
    score
  end

  private

  def create_frames(text_marks)
    parsed_marks = parse_marks(text_marks)
    frames_marks = create_frames_marks(parsed_marks)
    frames_marks.map { |marks| Frame.new(*marks) }
  end

  def parse_marks(text_marks)
    text_marks.split(',').map do |mark|
      mark.to_i if mark != 'X'
      mark
    end
  end

  # example: [["6", "3"], ["9", "0"], ["0", "3"], ["8", "2"], ["7", "3"], ["X"], ["9", "1"], ["8", "0"], ["X"], ["6", "4", "5"]]
  # example: [["X"], ["X"], ["X"], ["X"], ["X"], ["X"], ["X"], ["X"], ["X"], ["X", "X", "X"]]
  def create_frames_marks(parsed_marks)
    frames_marks = []
    current_frame_marks = []
    parsed_marks.each_with_index do |mark, index|
      current_frame_marks << mark
      if frames_marks.size == 9
        frames_marks << current_frame_marks if index == parsed_marks.size - 1 # 最後のmark
      elsif mark == 'X'
        frames_marks << current_frame_marks
        current_frame_marks = []
      elsif current_frame_marks.size == 2
        frames_marks << current_frame_marks
        current_frame_marks = []
      end
    end
    frames_marks
  end

  def strike_bonus(index)
    next_frame = @frames[index + 1]
    if index == 8
      next_frame.first_shot.score + next_frame.second_shot.score
    elsif next_frame.strike?
      next_frame.first_shot.score + @frames[index + 2].first_shot.score
    else
      next_frame.score
    end
  end

  def spare_bonus(index)
    @frames[index + 1].first_shot.score
  end
end
