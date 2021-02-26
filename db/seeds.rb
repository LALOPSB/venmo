# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

(1..50).each do
  User.create!(username: Faker::Name.first_name)
end

(1..50).each do |user_id|
  PaymentAccount.create!(
    user_id: user_id,
    balance: rand(0.0..1000.0).round(2)
  )
end

(1..50).each do |user_id|
  ExternalPaymentSource.create!(
    user_id: user_id,
    source_type: ['Bank Account', 'Visa card', 'Paypal'].sample
  )
end

Friendship.create!(user_id: 1, friend_id: 50)

(2..50).each do |user_id|
  friend_ids = ([*1..50] - [user_id]).sample(rand(1..3))
  friend_ids.each do |friend_id|
    Friendship.create!(
      user_id: user_id,
      friend_id: friend_id
    )
  end
end


User.all.each do |user|
  user.friends.each do |friend|
    (1..3).each do
      Payment.create!(
        sender: user,
        friend: friend,
        amount: rand(0.0..150.0).round(2),
        description: Faker::Lorem.sentence,
        created_at: rand(20160).minutes.ago
      )
    end
  end
end

User.create!(username: 'non-friend')




