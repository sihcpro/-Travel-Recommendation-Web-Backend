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

histories = CSV.read("./db/histories.csv")
print 'Create histories   : '
for row in histories
  history = History.new(user_id: row[0], travel_id: row[1], status: row[2])
  print '.' if history.save()
end
puts ' ok'

# while true
# end
