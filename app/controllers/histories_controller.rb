class HistoriesController < ApplicationController
  def show
    @all_histories = History.all
    save_result(@all_histories)
    render json: {
      all_histories: @all_histories
    }
  end

  def save_result(histories)
    File.open('result.csv', "w+") do |f|
      f.write("\
userId,itemId,\
rating,Start,\
Price,\
Date,Duration,\
\n")
      histories.each do |history|
        f.write("\
#{check(history.user_id)},#{check(history.travel_id)},\
#{check(history.travel.rating)},#{check(history.travel.start.city.name)},\
#{check(classify_price(history.travel.price))},\
#{check(history.travel.date)},#{check(history.travel.duration)},\
\n")
      end
    end
  end

  def check(str)
    if str
      return str
    else
      return 'NA'
    end
  end

  def classify_price(price)
    if price > 10000000
      return 'expensive'
    elsif price > 5000000
      return 'reasonable'
    else
      return 'cheap'
    end
  end
end
