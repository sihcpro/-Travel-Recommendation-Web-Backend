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
                                   password: "123456", gender: 0, role: 0).save
  puts 'Created Test'  if User.new(username: "test", email: "test@gmail.com",
                                   password: "123456", gender: 0, role: 1).save
  puts 'Default password: 123456'
  print 'Create user     : '
  (1..limit).each do |n|
    print '.' if User.new(username: "user#{n}", email: "user#{n}@b.c",
                          password: "123456", gender: n%2, role: 2).save
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

def build_price_steps()
  price_steps = CSV.read("./db/price_steps.csv")
  print 'Create PriceStep: '
  cnt = 0
  for row in price_steps
    cnt += 1
    print '.' if PriceStep.create(name: row[0])
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
                           # type_id: type_id,
                           duration: duration,
                           description: 'Not yet',)
        print '.' if travel.save()
        print '=' if TravelType.create(travel_id: travel.id,
                                       type_id: type_id,)
        print '>' if Destination.create(travel_id: travel.id,
                                        city_id: cities[destination_index].id,)
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
      # if !dict_size_of_travel[destination]
      #   dict_size_of_travel[destination] = City.find_by(id: destination).travel.size
      # end

      if user_characteristics['type']

        if user_characteristics['duration']
          travels = Destination.joins(:travel => :travel_type).where(city_id: destination, "travel_types.type_id" => type, "travels.duration" => duration).select("destinations.travel_id")
          (1..3).each do |i|
            travel = travels[rd.rand(0..(travels.size-1))]
            if !user_characteristics['price'] || 
              (user_characteristics['price'] && classify_price(travel.price) == price)
              cnt += 1 if Comment.create(user_id: user.id, travel_id: travel.travel_id, rating: comment[1], content: comment[0])
            end
          end
        else
          travels = Destination.joins(:travel => :travel_type).where(city_id: destination, "travel_types.type_id" => type).select("destinations.travel_id")
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
          travels = Destination.joins(:travel => :travel_type).where(city_id: destination, "travels.duration" => duration).select("destinations.travel_id")
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

def get_all_suggestions
  all_suggestions = {}
  (1..5).each do |i|
    line_number = 0
    File.readlines("./CARSKit.Workspace/CAMF_CU-top-1000-items fold [#{i}].txt").each do |line|
      line_number += 1
      next if line_number == 1
      user_id = line.match(/[\d]+/).to_s.to_i

      suggestions = line.scan(/\([^\(]+\)/)
      suggestions.each do |item|
        travel_id = item.match(/[\d]+,/).to_s.chomp(":").to_i
        rate = item.match(/[\d]+.[\d]+\)/).to_s.chomp(":").to_f

        # puts 1
        # puts user_id
        # puts all_suggestions[user_id]
        if all_suggestions[user_id] == nil
          # puts 2
          all_suggestions[user_id] = [[travel_id, rate]]
        else
          # puts 3
          all_suggestions[user_id] += [[travel_id, rate]]
        end
      end
    end
  end
  all_suggestions
end

def build_suggestions
  all_suggestions = get_all_suggestions()
  puts 'Create suggestion: '

  all_suggestions.each do |user_id, user_suggestions|
    print user_id
    user_suggestions[0..18].each do |suggestion|
      print '.' if Suggestion.create(user_id: user_id,
                                     travel_id: suggestion[0],
                                     rate: suggestion[1])
    end
    print '> '
  end
  puts 'Suggestion done'
end


def build_travel_manual
  locations = CSV.read("./db/location_sheet.csv")
  print 'Create locations: '
  for row in locations
    travel = Travel.new(title: row[0],
                        lower_price: row[1].to_i,
                        upper_price: row[2].to_i,
                        address: row[3],
                        location: row[4],
                        link: row[5],
                        description: row[8],
                        rating: 5,)
    print '.' if travel.save
    for type in row[6].split(" ").map{ |i| i.to_i }
      print '=' if TravelType.create(travel_id: travel.id, type_id: type)
    end
    destination = City.find_by(name: row[7])
    if destination
      print Destination.create(travel_id: travel.id, city_id: destination.id) ? '>' : '?'
    else
      print '!'
      print row[7]
    end
  end
  puts ' ok'
end


def build_comments
  comments = CSV.read("./db/Comment.csv")
  print 'Create comments : '
  line = 0
  for row in comments
    line += 1
    next if line == 1
    print '.' if Comment.create(travel_id: row[0].to_i,
                                user_id: row[1].to_i,
                                rating: row[2].to_i,
                                content: row[3],)
  end
  puts ' ok'
end

def build_favorite_types
  favorites = CSV.read("./db/UserFavorite.csv")
  print 'Create favorites: '
  line = 0
  for row in favorites
    line += 1
    next if line == 1
    row[1].split(' ').each do |type|
      print '.' if FavoriteType.create(user_id: row[0].to_i,
                                  type_id: type,)
    end
    print '>'
  end
  puts ' ok'
end

def update_rating_all_travels
  print 'Update rating   : '
  Travel.all.each do |travel|
    print '.' if travel.update_rating
  end
  puts '>'
end

def export_all_comments
  print 'Export result   : '
  File.open('result.csv', 'w+') do |f|
    f.write(Comment.first.head())
  Comment.all.each do |comment|
    f.write(comment.beauty)
    print '.'
    end
  end
  puts '>'
end

def check(str)
  str || 'NA'
end








if !Env.first
  puts "Create enviroments"
  Env.create(lock: 1, counts: 0)
end


if !User.first
  build_users((1000 * rate).round())
end

if !City.first
  build_cities()
end

if !Type.first
  build_types()
end

if !PriceStep.first
  build_price_steps()
end

if !Travel.first
  build_travel_manual()
end

if !Comment.first
  build_comments()
end

if !FavoriteType.first
  build_favorite_types()
end

# update_rating_all_travels()

# if !Comment.first
#   build_random_comments((10 * rate).round())
# end

# export_all_comments()
system("java -jar CARSKit-v0.3.5.jar -c setting.conf")

# Suggestion.all.delete_all
# build_suggestions()



