#!/usr/bin/env ruby

require 'date'

# 今日の [月・年] を表示
def print_today
  @today = Date.today
  puts("#{@today.month}月 #{@today.year}年")
end



# 曜日を表示
def print_day_of_week
  puts("日 月 火 水 木 金 土")
end

print_today
print_day_of_week
