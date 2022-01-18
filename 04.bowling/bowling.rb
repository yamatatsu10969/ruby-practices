#!/usr/bin/env ruby
# frozen_string_literal: true

@strike_sign = 'X'

# 引数を取得し、配列に変換
def create_score_array_from_command_argument
  string_score = ARGV[0]
  # 文字列から配列に分解する
  string_score.split(',')
end

# フレーム毎のスコアの配列を作成
# 引数の例： ["1, 8", "X",,,]
def create_frame_scores_array(string_scores)
  frame_count = 10
  frame_scores = []
  # 10個の配列に分けて、フレーム単位にする
  frame_count.times do |_|
    frame_scores.push([])
  end

  # 10個の配列にスコアを格納
  current_frame = 1
  string_scores.each do |score|
    current_scores_index = current_frame - 1
    current_scores = frame_scores[current_scores_index]
    current_scores.push(score)

    # ストライクが入っている時か、2投投げ終わった時は次のフレーム
    # ただし、10フレーム目は次のフレームがないので含まない
    current_frame += 1 if (current_scores.include?(@strike_sign) || current_scores.count == 2) && (current_frame != 10)
  end

  frame_scores
end

# ストライクの場合のスコアを、次のフレームと、その次のフレームから計算
def calculate_strike_score(next_frame_score:, after_next_frame_score:)
  if next_frame_score.include?(@strike_sign) && next_frame_score.length == 1
    # 次のフレームがストライクかつ、length == 1 の時(連続ストライク)は、次の次の１投目が反映される
    [@strike_sign, @strike_sign, after_next_frame_score[0]]
  else
    # 連続ストライク以外は次のフレームの2投を反映
    [@strike_sign, next_frame_score[0], next_frame_score[1]]
  end
end

# スペアのスコアの計算
def calculate_spare_score(frame_score:, next_frame_score:)
  frame_score.push(next_frame_score[0]) if [frame_score[0].to_i, frame_score[1].to_i].sum == 10
end

# フレームのスコアに、スペアとストライクによる得点を加算する
def create_calculated_frame_score_array_when_spare_or_strike(frame_scores)
  frame_scores.map!.with_index do |scores, frame_index|
    # 最終フレームはそのままスコアを反映
    next scores if frame_index == 9

    next_frame_score = frame_scores[frame_index + 1]
    if scores.include?(@strike_sign)
      next calculate_strike_score(next_frame_score: next_frame_score, after_next_frame_score: frame_scores[frame_index + 2]) if scores.include?(@strike_sign)
    # スペアの時
    elsif [scores[0].to_i, scores[1].to_i].sum == 10
      next calculate_spare_score(frame_score: scores, next_frame_score: next_frame_score[0]) if [scores[0].to_i, scores[1].to_i].sum == 10
    else
      next scores
    end
  end

  frame_scores
end

# 合計値を計算
def calculate_total_score(calcurated_frame_score:)
  # すべて数字に変更
  calcurated_frame_score.map! do |scores|
    scores.map! do |score|
      if score == @strike_sign
        10
      else
        score.to_i
      end
    end
    next scores.sum
  end
  calcurated_frame_score.sum
end

# 実行部分
string_scores = create_score_array_from_command_argument
frame_scores = create_frame_scores_array(string_scores)
calcurated_frame_score = create_calculated_frame_score_array_when_spare_or_strike(frame_scores)
p calculate_total_score(calcurated_frame_score: calcurated_frame_score)
