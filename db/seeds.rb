# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

20.times do |n|
  Player.create(name: "player#{n+1}", phone_number: "626173827#{n}", status: "Playing")
end

8.times do |n|
  Room.create(name: "room#{n+1}", description: "create room#{n+1}")
end