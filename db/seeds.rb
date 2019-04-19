# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require 'time'
require 'csv'

def build_user
  puts 'Created Admin' if User.new(username: "Bang", email: "equal@gmail.com",
                                   password: "123456", gender: 0, role: 2).save
  puts 'Created Test'  if User.new(username: "test", email: "test",
                                   password: "123456", gender: 0, role: 1).save
  puts 'Default password: 123456'
  print 'Create user     : '
  (1..500).each do |n|
    print '.' if User.new(username: "user#{n}", email: "user#{n}",
                          password: "123456", gender: n%2, role: 0).save
  end
  puts 'ok'
end

def build_cities
  cities = CSV.read("./db/cities.csv")
  print 'Create cities   : '
  for row in cities
    city = City.new(name: row[0], rating: 3.0)
    print '.' if city.save()
  end
  puts ' ok'
end

def build_random_travel
  print('Create travels  : ')
  cities = City.all()
  (0..(cities.size-2)).each do |start_id|
    ((start_id+1)..(cities.size-1)).each do |destination_id|
      ['weekday', 'weekend'].each do |date|
        if ['Đà Nẵng', 'Hồ Chí Minh',
            'Hà Nội', 'Lâm Đồng'].include?(cities[destination_id])
          rating = 5
        else
          rating = 4
        end
        price = (destination_id - start_id).abs * 200000 + 1000000
        if date == 'weekend'
          price = (price * 1.3).round(-5)
        end
        duration = ((destination_id - start_id).abs * 0.25 + 1).round()

        travel = Travel.new(title: cities[destination_id].name,
                            price: price,
                            rating: rating,
                            date: date,
                            duration: duration,
                            description: 'Not yet')
        print '-' if travel.save()
        # puts travel.inspect
        # puts travel.id
        # puts 'Start: ' + cities[start_id].id.to_s
        start = Start.new(travel_id: travel.id,
                          city_id: cities[start_id].id)
        print '=' if start.save()
        # puts 'Destination: ' + cities[destination_id].name
        destination = Destination.new(travel_id: travel.id,
                                      city_id: cities[destination_id].id)
        print '>' if destination.save()
      end
    end
  end
  puts ' ok'
end

def build_random_history
  rd = Random.new(Time.now.to_i)
  starts = Start.select('city_id').all.distinct.map{|i| i.city_id}
  prices = ['expensive', 'reasonable', 'cheap']
  dates = ['weekday', 'weekend']
  durations = Travel.select('duration').all.distinct.map{|i| i.duration}

  all_user = User.all
  user = User.first

  print('Create histories: ')

  all_user.each do |user|
    amount_of_travel = rd.rand(1..10)
    rd_a =   [rd.rand(1..5), rd.rand(1..5), rd.rand(1..5), rd.rand(1..5)]
    bool_a = [rd_a[0] > 1  , rd_a[1] > 2  , rd_a[2] > 3  , rd_a[3] > 4  ]
    #         starts       , prices       , date         , duration
    user_characteristics = {
      'start': bool_a[0],
      'price': bool_a[1],
      'date': bool_a[2],
      'duration': bool_a[3]
    }
    dict_size_of_travel = {}

    # puts bool_a

    start = rd.rand(1..(starts.size))
    date  = dates[rd.rand(0..(dates.size-1))]
    price = prices[rd.rand(0..(prices.size-1))]
    duration = durations[rd.rand(0..(durations.size-1))]

    cnt = 0
    while(cnt < amount_of_travel)
      if !user_characteristics['start']
        start = rd.rand(1..(starts.size))
      end

      # using dict to save reues value
      if !dict_size_of_travel[start]
        dict_size_of_travel[start] = City.find(start).travel.size
      end

      if user_characteristics['date']
        if user_characteristics['duration']
          travels = City.find(start).travel.where(date: date, duration: duration)
          (1..3).each do |i|
            travel = travels[rd.rand(0..(travels.size-1))]
            if !user_characteristics['price'] || 
              (user_characteristics['price'] && classify_price(travel.price) == price)
              cnt += 1 if History.create(user_id: user.id, travel_id: travel.id)
            end
          end
        else
          travels = City.find(start).travel.where(date: date)
          (1..3).each do |i|
            travel = travels[rd.rand(0..(travels.size-1))]
            if !user_characteristics['price'] || 
              (user_characteristics['price'] && classify_price(travel.price) == price)
              cnt += 1 if History.create(user_id: user.id, travel_id: travel.id)
            end
          end
        end
      else
        if user_characteristics['duration']
          travels = City.find(start).travel.where(duration: duration)
          (1..3).each do |i|
            travel = travels[rd.rand(0..(travels.size-1))]
            if !user_characteristics['price'] || 
              (user_characteristics['price'] && classify_price(travel.price) == price)
              cnt += 1 if History.create(user_id: user.id, travel_id: travel.id)
            end
          end
        else
          travels = City.find(start).travel
          (1..3).each do |i|
            travel = travels[rd.rand(0..(travels.size-1))]
            if !user_characteristics['price'] || 
              (user_characteristics['price'] && classify_price(travel.price) == price)
              cnt += 1 if History.create(user_id: user.id, travel_id: travel.id)
            end
          end
        end
      end
    end
    print('.')
  end
  puts ' ok'
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

def build_suggestions
  # suggestions = 
  print 'Create suggestion: '
  line_number = 0
  File.readlines("./CARSKit.Workspace/CAMF_CU-top-1000-items fold [1].txt").each do |line|
    line_number += 1
    next if line_number == 1
    break if line_number == 3
    user_id = line.match(/[\d]+/).to_s.to_i
    favorites = line.scan(/[\w ]+:[\w ]+;/u)
    suggestions = line.scan(/\([^\(]+\)/)
    # puts user_id
    # puts favorites
    # puts suggestions

    favorite_map = {}
    favorites.each do |item|
      title = item.match(/[\w ]+:/u).to_s.chomp(":")
      value = item.match(/[\w ]+;/u).to_s.chomp(";")
      favorite_map[title] = value
    end
    favorite = Favorite.new(user_id: user_id, price: favorite_map['price'],
                            date: favorite_map['date'],
                            duration: favorite_map['duration'].to_s.to_i)
    print '-' if favorite.save()
    puts favorite.inspect

    suggestions.each do |item|
      travel_id = item.match(/[\d]+,/).to_s.chomp(":").to_i
      rate = item.match(/[\d]+.[\d]+\)/).to_s.chomp(":").to_f

      suggestion = Suggestion.new(user_id: user_id, travel_id: travel_id,
                                  rate: rate)

      print '.' if suggestion.save()
      # break
    end
  end
  puts ' ok'
end


if !User.first
  build_user()
end

if !City.first
  build_cities()
end

if !Travel.first
  build_random_travel()
end

if !History.first
  build_random_history()
end

# system("java -jar CARSKit-v0.3.5.jar -c setting.conf")

if !Suggestion.first
  build_suggestions()
end




