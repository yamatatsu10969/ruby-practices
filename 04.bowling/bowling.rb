# sample_input = "6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4" # これ間違っている

# sample_input = '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'
sample_input = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'
# sample_input = 'X,X,X,X,X,X,X,X,X,X,X,X'

frame_count = 10
strike_sign = 'X'

# 引数をもらう

# 文字列から配列に分解する
scores = sample_input.split(',')

# 10個の配列に分けて、フレーム単位にする
frame_scores = []
frame_count.times do |_|
  frame_scores.push([])
end

p frame_scores.length

# 10個の配列にスコアを格納
current_frame = 1
scores.each do |score|
  current_scores_index = current_frame - 1
  current_scores = frame_scores[current_scores_index]
  current_scores.push(score)

  # ストライクが入っている時か、2投投げ終わった時は次のフレーム
  # ただし、10フレーム目は次のフレームがないので含まない
  current_frame += 1 if (current_scores.include?(strike_sign) || current_scores.count == 2) && (current_frame != 10)
end

p current_frame
p frame_scores
# p frame_int_scores

frame_scores.map!.with_index do |scores, frame_index|
  p frame_index
  if (frame_index == 9)
    p 'hogehog'
    scores
  end

  next_frame_score = frame_scores[frame_index + 1]
  # if scores.include?(strike_sign)
  #   if next_frame_score.include?(strike_sign && next_frame_score.length == 1)
  #     after_next_frame_score = after_next_frame_score[frame_index + 2]
  #     [strike_sign, strike_sign, after_next_frame_score[0]]
  #   else
  #     [strike_sign, next_frame_score[0], next_frame_score[1]]
  #   end
  # end

  if [scores[0].to_i, scores[1].to_i].sum == 10
    scores.push(next_frame_score[0])
  else
    scores
  end
end

p frame_scores


# すべて数字に変更
frame_scores.map! do |scores|
  if scores.include?(strike_sign)
    [10]
  else
    [scores.first.to_i, scores.last.to_i]
  end
end

p frame_scores


# is_previous_score_spare = false
# is_previous_score_strike = false
# total_score = 0

# frame_scores.map.with_index do |scores, frame_index|
#   add_score = 0
#   p scores
#   scores.map.with_index do |score, score_index|
#     score_number = score == strike_sign ? 10 : score
#     add_score = score_number

#     if is_previous_score_spare
#       p 'スペア分を足すよ'
#       add_score += score_number
#       is_previous_score_spare = false
#     elsif is_previous_score_strike
#       p 'ストライク分を足すよ'
#       add_score += score_number
#     end
#     if frame_index > 1
#       if frame_scores[frame_index - 1] == [10] && frame_scores[frame_index - 2] == [10] && score_index != 1
#         p 'ストライクの余剰分をさらに足すよ'
#         add_score += score_number
#       end
#     end


#     total_score += add_score
#     print 'add: '
#     p add_score

#   end

#   print 'total: '
#   p total_score

#   if scores == [10]
#     p 'ストライクだよ！'
#     is_previous_score_strike = true
#   else
#     int_scores = scores.map { |score| score }
#     if int_scores.sum == 10
#       p 'スペア~~~'
#       is_previous_score_spare = true
#     else
#       is_previous_score_strike = false
#     end
#   end
#   p '----------------'
# end
