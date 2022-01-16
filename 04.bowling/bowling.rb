# sample_input = "6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4" # これ間違っている
# sample_input = "0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4"
sample_input = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'

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
