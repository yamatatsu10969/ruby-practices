#!/usr/bin/env ruby
# frozen_string_literal: true

STRIKE_SIGN = 'X'
STRIKE_SIGN.freeze

def main
  string_scores = create_score_array_from_command_argument
  frame_scores = create_frame_scores_array(string_scores)
  calculated_frame_scores = create_calculated_frame_score_array_when_spare_or_strike(frame_scores)
  p calculate_total_score(calculated_frame_score: calculated_frame_scores)
end

def strike?(frame_score)
  frame_score.include?(STRIKE_SIGN)
end

def spare?(frame_score)
  [frame_score[0].to_i, frame_score[1].to_i].sum == 10
end

def frame_end?(frame_scores)
  strike?(frame_scores) || frame_scores.count == 2
end

def last_frame?(frame_count)
  frame_count == 10
end

def create_score_array_from_command_argument
  string_score = ARGV[0]
  string_score.split(',')
end

def create_frame_scores_array(string_scores)
  frame_count = 10
  frame_scores = []
  frame_count.times do |_|
    frame_scores.push([])
  end

  current_frame = 1
  string_scores.each do |score|
    current_scores_index = current_frame - 1
    current_scores = frame_scores[current_scores_index]
    current_scores.push(score)
    current_frame += 1 if frame_end?(current_scores) && !last_frame?(current_frame)
  end

  frame_scores
end

def calculate_strike_scores(next_frame_score:, after_next_frame_score:)
  if !after_next_frame_score
    [STRIKE_SIGN, next_frame_score[0], next_frame_score[1]]
  elsif strike?(next_frame_score)
    [STRIKE_SIGN, STRIKE_SIGN, after_next_frame_score[0]]
  else
    [STRIKE_SIGN, next_frame_score[0], next_frame_score[1]]
  end
end

def calculate_spare_score(frame_score:, next_frame_score:)
  frame_score.push(next_frame_score[0])
end

def create_calculated_frame_score_array_when_spare_or_strike(frame_scores)
  frame_scores.map.with_index do |scores, frame_index|
    next_frame_score = frame_scores[frame_index + 1]
    if frame_index == 9
      scores
    elsif strike?(scores)
      calculate_strike_scores(next_frame_score: next_frame_score, after_next_frame_score: frame_scores[frame_index + 2])
    elsif spare?(scores)
      calculate_spare_score(frame_score: scores, next_frame_score: next_frame_score[0])
    else
      scores
    end
  end
end

def calculate_total_score(calculated_frame_score:)
  calculated_frame_score.flatten.sum do |score|
    if score == STRIKE_SIGN
      10
    else
      score.to_i
    end
  end
end

main
