# frozen_string_literal: true

# sample_input = "6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5" # 139

# sample_input = '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4' # 107
# sample_input = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0' # 134
# sample_input = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X' # 164
sample_input = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8' # 144
# sample_input = 'X,X,X,X,X,X,X,X,X,X,X,X' # 300

@strike_sign = 'X'

# 引数を取得し、配列に変換
def create_score_array_from_command_argument
  string_score = ARGV[0]
  # 文字列から配列に分解する
  string_score.split(',')
end

# フレーム毎のスコアの配列を作成
# 引数の例： ["1", "X",,,]
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

string_scores = create_score_array_from_command_argument
frame_scores = create_frame_scores_array(string_scores)

p frame_scores

frame_scores.map!.with_index do |scores, frame_index|
  p frame_index

  next scores if frame_index == 9

  next_frame_score = frame_scores[frame_index + 1]
  if scores.include?(@strike_sign)
    p 'strike だよ'
    if next_frame_score.include?(@strike_sign) && next_frame_score.length == 1
      after_next_frame_score = frame_scores[frame_index + 2]
      next [@strike_sign, @strike_sign, after_next_frame_score[0]]
    else
      next [@strike_sign, next_frame_score[0], next_frame_score[1]]
    end
  end

  next scores.push(next_frame_score[0]) if [scores[0].to_i, scores[1].to_i].sum == 10

  next scores
end

p frame_scores

# すべて数字に変更
frame_scores.map! do |scores|
  scores.map! do |score|
    if score == @strike_sign
      10
    else
      score.to_i
    end
  end
  next scores.sum
end

p frame_scores.sum
