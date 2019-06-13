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
  puts 'Created Admin' if User.new(username: "Thanh Bằng", email: "equal@gmail.com",
                                   password: "123456", gender: 0, role: 0).save
  puts 'Created Test'  if User.new(username: "test", email: "test@gmail.com",
                                   password: "123456", gender: 0, role: 1).save
  puts 'Default password: 123456'

  print 'Create user     : '
  users = CSV.read("./db/user_names.csv")
  n = 0
  for row in users
    n+= 1
    break if n > limit
    print '.' if User.new(username: row[0],
                          email: "user#{n}@gmail.com",
                          password: "123456",
                          gender: n%2,
                          role: 2).save
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

def get_all_suggestions
  # Read suggestion from 5 file
  all_suggestions = {}
  (1..5).each do |i|
    line_number = 0
    File.readlines("./CARSKit.Workspace/CAMF_CI-top-10-items fold [#{i}].txt").each do |line|
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

  # Distinct and sort
  all_suggestions.each do |key, suggestions|
    tmp_suggestions_dict = {}
    # Get hightest rating for a travel that repeated
    all_suggestions[key].each_with_index do |suggestion, i|
      if tmp_suggestions_dict[suggestion[0]] == nil
        tmp_suggestions_dict[suggestion[0]] = suggestion
      elsif tmp_suggestions_dict[suggestion[0]][1] < suggestion[1]
        tmp_suggestions_dict[suggestion[0]] = suggestion
      end
    end

    # Dict to array
    tmp_suggestions_arr = []
    tmp_suggestions_dict.each do |key, suggestion|
      tmp_suggestions_arr += [suggestion]
    end

    # Sort
    all_suggestions[key] = tmp_suggestions_arr.sort_by{ |a| [ a[1] ] }.reverse
  end
  all_suggestions
end

def build_suggestions
  users = User.all.select(:id).map(&:id)
  users.each do |user_id|
    print "#{user_id}>"
    system("java -jar Recommender.jar -c setting.conf -u #{user_id}")
    travels = []
    File.open("CARSKit.Workspace/user#{user_id}_suggestion.txt", 'r') do |f|
      travel_all = f.read().split("\n")
      puts travel_all.to_s
      travel_all.each do |travel|
        travel = travel.split(',')
        travels = travels + [[travel[0].to_i, travel[1].to_f]]
      end
      travels = travels.sort_by{ |a| [ a[1] ] }.reverse
    end
    puts travels.to_s
    travels[0..9].each_with_index do |travel, idx|
      print '.' if Suggestion.create(user_id: user_id,
                                     travel_id: travel[0],
                                     rate: travel[1])
    end
    print '< '
  end
end


def build_travel_manual(limit = 100)
  locations = CSV.read("./db/location_sheet.csv")
  print 'Create locations: '
  cnt = 0
  for row in locations
    cnt += 1
    break if cnt > limit
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
  rd = Random.new(Time.now.to_i)
  comments = CSV.read("./db/comment_sheet.csv")
  print 'Create comments : '
  line = 0
  for row in comments
    line += 1
    next if line == 1
    print '.' if Comment.create(user_id: row[0].to_i,
                                travel_id: row[1].to_i,
                                rating: row[2].to_i,
                                content: "",
                                partner: row[3],
                                time: row[4],
                                created_at: Time.now - rd.rand(1..365) * 60 * 60 * 24)
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
    if travel && travel.comments.count > 0
      if travel.update_rating
        print '.'
      else
        print '!'
      end
    else
      print '?'
    end
  end
  puts ' ok'
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
  build_users(10)
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
  build_travel_manual(30)
end

if !Comment.first
  build_comments()
end

if !FavoriteType.first
  build_favorite_types()
end

update_rating_all_travels()

export_all_comments()
system("java -jar BuildModel.jar -c setting.conf")

Suggestion.all.delete_all
build_suggestions()



