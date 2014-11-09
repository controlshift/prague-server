# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!(
  email: 'user@mail.com',
  password: '11111111',
  password_confirmation: '11111111',
  confirmed_at: Time.now ,
  confirmation_sent_at: Time.now - 1.day
)