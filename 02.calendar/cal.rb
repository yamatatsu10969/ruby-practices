#!/usr/bin/env ruby

require 'date'
require 'optparse'

# 引数がない時のためにデフォルトで今日の年・月を表示する
default_year = Date.today.year
default_month = Date.today.month
@input_year = default_year
@input_month = default_month

# -m で month の引数を取得する
# -y で year の引数を取得する
def recognize_options
  option = OptionParser.new
  option.on('-y VAL') {|year|
    # string が渡ってくるので int に変換
    input_year = year.to_i
    if (1970 <= input_year && input_year <= 2100)
      @input_year = input_year
    else
      puts '-y(年)は 1970 ~ 2100 を指定してください'
    end
  }

  option.on('-m VAL') { |month|
    # string が渡ってくるので int に変換
    input_month = month.to_i
    if (1 <= input_month && input_month <= 12)
      @input_month = input_month
    else
      puts '-m(月)は 1 ~ 12 を指定してください'
    end
  }

  # 他のオプションがきたときも処理を継続させる
  begin
    option.parse!(ARGV)
  rescue => exception
    puts '-m, -y 以外のオプションは指定できません\n'
    puts '\n'
  end
end

# [月・年] を表示
def print_month_year(input_date)
  puts('      #{input_date.month}月 #{input_date.year}年')
end

# 曜日を表示
def print_day_of_week
  puts(' 日 月 火 水 木 金 土')
end

# Dateから日付を表示する
def print_dates(input_date)
  @first_date = Date.new(input_date.year, input_date.month, 1)
  @last_date = Date.new(input_date.year, input_date.month, -1)

  for date in @first_date..@last_date
    @print_day = date.mday.to_s

    # 数字が一桁の場合、インデントがずれるため空文字を先頭に追加
    if (@print_day.length == 1)
      @print_day.insert(0, ' ')
    end

    # 最初の日付(1日)の場合はインデントを調整する
    if (date.mday == 1 && date.wday != 0)
      print('   ' * date.wday)
    end

    # 土曜日の後は改行する
    if (date.saturday?)
      @print_day = @print_day + '\n'
    end

    # ' ' の空文字を入れることで前の数字とのスペースを作成
    print(' ')

    if (date.year == Date.today.year && date.month == Date.today.month && date.mday == Date.today.mday)
      # 出力を反転させる [Rubyで出力に色を付ける方法 - Qiita](https://qiita.com/khotta/items/9233a9ffeae68b58d84f)
      print '\e[7m' # 7は反転
      print(@print_day)
      print '\e[0m' # 0 は取り消し
    else
      # print の出力は改行しない
      print(@print_day)
    end
  end
end

recognize_options
print_month_year(Date.new(@input_year, @input_month))
print_day_of_week
print_dates(Date.new(@input_year, @input_month))
