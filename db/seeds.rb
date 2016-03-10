# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 20.times do |n|
#   Player.create(phone_number: "626173827#{n}", status: "Playing")
# end

# 8.times do |n|
#   Room.create(name: "room#{n+1}", description: "create room#{n+1}")
# end

5.times do |n|
  Player.create(display_name: "player#{n+2}", email: "player#{n+2}.gmail.com", role: "player", room_id: 3)
end

keyword_pair = [["Accounting", "Finance"], ["Fingers", "Toes"], ["sparrow", "crow"], ["Eyebrow", "Beard"], ["Superman", "Iron Man"], ["Bodyguard", "Security"], ["
Chili", "Mustard"], ["Lipstick", "Lip-gross"], ["Spiderman", "Batman"], ["Contact Lens", "Sunglasses"]]

keyword_pair.each do |pair|
  Keyword.create(keyword_one: pair[0], keyword_two: pair[1])
end
