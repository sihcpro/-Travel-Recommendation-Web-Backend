# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require 'time'
require 'csv'

rate = 0.2

def build_users(limit=500)
  puts 'Created Admin' if User.new(username: "Bang", email: "equal@gmail.com",
                                   password: "123456", gender: 0, role: 2).save
  puts 'Created Test'  if User.new(username: "test", email: "test",
                                   password: "123456", gender: 0, role: 1).save
  puts 'Default password: 123456'
  print 'Create user     : '
  (1..limit).each do |n|
    print '.' if User.new(username: "user#{n}", email: "user#{n}@b.c",
                          password: "123456", gender: n%2, role: 0).save
  end
  puts 'ok'
end

def build_cities(limit=63)
  cities = CSV.read("./db/cities.csv")
  print 'Create cities   : '
  cnt = 0
  for row in cities
    cnt += 1
    break if cnt == limit
    city = City.new(name: row[0], rating: 3.0)
    print '.' if city.save()
  end
  puts ' ok'
end

def build_types()
  types = CSV.read("./db/types.csv")
  print 'Create types    : '
  cnt = 0
  for row in types
    cnt += 1
    print '.' if Type.create(name: row[0])
  end
  puts ' ok'
end

def build_tours()
  rd = Random.new(Time.now.to_i)
  print('Create travels  : ')
  cities = City.all()
  types = Type.select(:id).all()
  (0..cities.size-1).each do |destination_index|
    types.map{|i| i.id}.each do |type_id|
      # ['weekday', 'weekend'].each do |date|
      ['weekday'].each do |date|
        rating = 5
        price = (100 - destination_index + rd.rand(0..40) - 20) * 100000
        if destination_index <= 10
          price += 1000000
        end
        price = price.round(-5)
        if date == 'weekend'
          price = (price * 1.3).round(-5)
        end
        duration = (price / 2000000 + 1).round()

        travel = Travel.new(title: cities[destination_index].name,
                           price: price,
                           rating: rating,
                           date: date,
                           type_id: type_id,
                           duration: duration,
                           description: 'Not yet',)
        print '.' if travel.save()
        # start = Start.new(travel_id: travel.id,
        #                   city_id: cities[start_id].id)
        # print '=' if start.save()
        print '>' if Destination.create(travel_id: travel.id,
                                        city_id: cities[destination_index].id)
      end
    end
  end
  puts ' ok'
end

def get_random_comments()
  random_comments = CSV.read("./db/comments.csv")
  random_comments.map{|i| i[1] = i[1].to_i()}
end


def build_random_comments(size=10)
  rd = Random.new(Time.now.to_i)

  random_comments = get_random_comments()
  destinations = Destination.select('city_id').all.distinct.map{|i| i.city_id}
  prices = ['expensive', 'reasonable', 'cheap']
  types = Type.all
  durations = Travel.select('duration').all.distinct.map{|i| i.duration}
  all_user = User.all

  # user = User.first
  puts destinations.size, prices.size, types.size, durations.size, all_user.size, random_comments.size
  print('Create comments: ')

  all_user.each do |user|
    amount_of_travel = rd.rand(1..[1,size].max)
    rd_a =   [rd.rand(1..5), rd.rand(1..5), rd.rand(1..5), rd.rand(1..5)]
    bool_a = [rd_a[0] > 1  , rd_a[1] > 2  , rd_a[2] > 3  , rd_a[3] > 4  ]
    #         starts       , prices       , types         , duration
    user_characteristics = {
      'destination': bool_a[0],
      'price': bool_a[1],
      'type': bool_a[2],
      'duration': bool_a[3]
    }
    dict_size_of_travel = {}

    # puts random_comments.size

    destination = destinations[rd.rand(0..(destinations.size-1))]
    type  = types[rd.rand(0..(types.size-1))]
    price = prices[rd.rand(0..(prices.size-1))]
    duration = durations[rd.rand(0..(durations.size-1))]

    cnt = 0
    while(cnt < amount_of_travel)
      # cnt = 100000
      if !user_characteristics['destination']
        destination = destinations[rd.rand(0..(destinations.size-1))]
      end

      comment = random_comments[rd.rand(0..(random_comments.size-1))]

      # using dict to save reues value
      if !dict_size_of_travel[destination]
        dict_size_of_travel[destination] = City.find_by(id: destination).travel.size
      end

      if user_characteristics['type']

        if user_characteristics['duration']
          travels = Destination.joins(:travel).where(city_id: destination, type: type, duration: duration).select("destinations.travel_id")
          (1..3).each do |i|
            travel = travels[rd.rand(0..(travels.size-1))]
            if !user_characteristics['price'] || 
              (user_characteristics['price'] && classify_price(travel.price) == price)
              cnt += 1 if Comment.create(user_id: user.id, travel_id: travel.travel_id, rating: comment[1], content: comment[0])
            end
          end
        else
          travels = Destination.joins(:travel).where(city_id: destination, type: type).select("destinations.travel_id")
          (1..3).each do |i|
            travel = travels[rd.rand(0..(travels.size-1))]
            if !user_characteristics['price'] || 
              (user_characteristics['price'] && classify_price(travel.price) == price)
              cnt += 1 if Comment.create(user_id: user.id, travel_id: travel.travel_id, rating: comment[1], content: comment[0])
            end
          end
        end
      else
        if user_characteristics['duration']
          travels = Destination.joins(:travel).where(city_id: destination, duration: duration).select("destinations.travel_id")
          next if !travels
          (1..3).each do |i|
            travel = travels[rd.rand(0..(travels.size-1))]
            if !user_characteristics['price'] || 
              (user_characteristics['price'] && classify_price(travel.price) == price)
              cnt += 1 if Comment.create(user_id: user.id, travel_id: travel.travel_id, rating: comment[1], content: comment[0])
            end
          end
        else
          travels = Destination.where(city_id: destination).select("destinations.travel_id")
          (1..3).each do |i|
            travel = travels[rd.rand(0..(travels.size-1))]
            if !user_characteristics['price'] || 
              (user_characteristics['price'] && classify_price(travel.price) == price)
              cnt += 1 if Comment.create(user_id: user.id, travel_id: travel.travel_id, rating: comment[1], content: comment[0])
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
  puts 'Create suggestion: '

  (1..5).each do |i|
    line_number = 0
    print "-> #{i} : "
    File.readlines("./CARSKit.Workspace/CAMF_CU-top-1000-items fold [#{i}].txt").each do |line|
      line_number += 1
      next if line_number == 1
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
      if !Favorite.find_by(user_id: user_id)
        favorite = Favorite.new(user_id: user_id, price: favorite_map['price'],
                                date: favorite_map['date'],
                                duration: favorite_map['duration'].to_s.to_i)
        print '>' if favorite.save()
        # puts favorite.inspect

        suggestions.each do |item|
          travel_id = item.match(/[\d]+,/).to_s.chomp(":").to_i
          rate = item.match(/[\d]+.[\d]+\)/).to_s.chomp(":").to_f

          suggestion = Suggestion.new(user_id: user_id, travel_id: travel_id,
                                      rate: rate)

          print '.' if suggestion.save()
          # break
        end
      end
    end
    puts ' ok'
  end
  puts 'Suggestion done'
end








if !User.first
  build_users((1000 * rate).round())
end

if !City.first
  build_cities((63 * rate).round())
end

if !Type.first
  build_types()
end

if !Travel.first
  build_tours()
end

if !Comment.first
  build_random_comments((10 * rate).round())
end

# system("java -jar CARSKit-v0.3.5.jar -c setting.conf")

build_suggestions()



