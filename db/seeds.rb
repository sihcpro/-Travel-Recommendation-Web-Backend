# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'


puts 'Created Admin' if User.new(name: "Bang", email: "equal@gmail.com", password: "123456", gender: 0, role: 2).save
puts 'created Test'  if User.new(name: "Test", email: "test", password: "test").save


cities = CSV.read("./db/cities.csv")
print 'Create city: '
for row in cities
    city = City.new(name: row[0], rating: 3.0)
    print '.' if city.save()
end
puts ' ok!'


travels = CSV.read("./db/travel.csv")
print 'Create travel: '
for row in travels
    travel = Travel.new(title: row[1], price: row[2], rating: row[3],
                        from: row[4], to: row[5],
                        start_time: row[6], duration: row[7],
                        description: row[8]
                        )
    print '.' if travel.save()
end
puts ' ok!'


# while true
# end
