#!/usr/bin/env ruby

require 'date'

# [月・年] を表示
def print_month_year(inputDate)
  puts("      #{inputDate.month}月 #{inputDate.year}年")
end

# 曜日を表示
def print_day_of_week
  puts(" 日 月 火 水 木 金 土")
end

# Dateから日付を表示する
def print_dates(inputDate)
  @first_date = Date.new(inputDate.year, inputDate.month, 1)
  @last_date = Date.new(inputDate.year, inputDate.month, -1)

  for date in @first_date..@last_date
    @print_day = date.mday.to_s

    # 数字が一桁の場合、インデントがずれるため空文字を先頭に追加
    if (@print_day.length == 1)
      @print_day.insert(0, " ")
    end

    # 最初の日付(1日)の場合はインデントを調整する
    if (date.mday == 1 && date.wday != 0)
      @print_day.insert(0, "   " * date.wday)
    end

    # 土曜日の後は改行する
    if (date.saturday?)
      @print_day = @print_day + "\n"
    end

    # " " の空文字を入れることで前の数字とのスペースを作成
    @print_day.insert(0, " ")

    # print の出力は改行しない
    print(@print_day)
  end
end

print_month_year(Date.new(2022, 12))
print_day_of_week
print_dates(Date.new(2022, 12))