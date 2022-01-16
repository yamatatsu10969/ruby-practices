#!/usr/bin/env ruby

require 'date'

# 今日の日付を表示
def print_today
  @today = Date.today
  puts("#{@today.month}月 #{@today.year}年")
end

print_today