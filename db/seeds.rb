# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require 'csv'

puts 'Created Admin' if User.new(username: "Bang", email: "equal@gmail.com", password: "123456", gender: 0, role: 2).save
puts 'Created Test'  if User.new(username: "test", email: "test", password: "123456", gender: 0, role: 1).save
puts 'Default password: 123456'
print 'Create user        : '
(1..100).each do |n|
  print '.' if User.new(username: "user#{n}", email: "user#{n}", password: "123456", gender: n%2, role: 0).save
end
puts 'ok'


cities = CSV.read("./db/cities.csv")
print 'Create cities      : '
for row in cities
  city = City.new(name: row[0], rating: 3.0)
  print '.' if city.save()
end
puts ' ok'


travels = CSV.read("./db/travels.csv")
print 'Create travels     : '
for row in travels
  travel = Travel.new(title: row[0], price: row[1], rating: row[2],
                      date: row[3], duration: row[4],
                      description: row[5])
  print '-' if travel.save()
  start = Start.new(travel_id: travel.id,
                    city_id: City.find_by(name: row[6]).id)
  print '=' if start.save()
  destination = Destination.new(travel_id: travel.id,
                                city_id: City.find_by(name: row[7]).id)
  print '>' if destination.save()
end
puts ' ok'

# starts = CSV.read("./db/starts.csv")
# print 'Create starts      : '
# for row in starts
#   start = Start.new(travel_id: row[0], city_id: row[1])
#   print '.' if start.save()
# end
# puts ' ok'

# destination = CSV.read("./db/destinations.csv")
# print 'Create destinations: '
# for row in destination
#   destination = Destination.new(travel_id: row[0], city_id: row[1])
#   print '.' if destination.save()
# end
# puts ' ok'

# histories = CSV.read("./db/histories.csv")
# print 'Create histories   : '
# for row in histories
#   history = History.new(user_id: row[0], travel_id: row[1], status: row[2])
#   print '.' if history.save()
# end
# puts ' ok'

def build_random
  starts = Start.select('city_id').all.distinct.map{|i| i.city_id}
  prices = ['expensive', 'reasonable', 'cheap']
  dates = ['weekday', 'weekend']
  durations = Travel.select('duration').all.distinct.map{|i| i.duration}

  require 'time'
  # puts Time.now.to_i
  rd = Random.new(Time.now.to_i)

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

build_random()

# while true
# end
