#!/usr/bin/env ruby

require 'date'
require 'optparse'

# 引数がない時のためにデフォルトで今日の年・月を表示する
defaultYear = Date.today.year
defaultMonth = Date.today.month
@inputYear = defaultYear
@inputMonth = defaultMonth

# -m で month の引数を取得する
# -y で year の引数を取得する
def recognizeOptions

  option = OptionParser.new

  # TODO: 少なくとも1970年から2100年までは正しく表示される
  option.on('-y VAL') {|year|
    # string が渡ってくるので int に変換
    @inputYear = year.to_i
  }
  # TODO: 少なくとも1970年から2100年までは正しく表示される
  option.on('-m VAL') { |month|
    @inputMonth = month.to_i
  }

  # 他のオプションがきたときも処理を継続させる
  begin
    option.parse!(ARGV)
  rescue => exception
    puts "-m, -y 以外のオプションは指定できません\n"
    puts "\n"
  end
end

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


recognizeOptions
print_month_year(Date.new(@inputYear, @inputMonth))
print_day_of_week
print_dates(Date.new(@inputYear, @inputMonth))


