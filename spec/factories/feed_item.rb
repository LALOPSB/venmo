FactoryBot.define do
  factory :payment do
    amount { Faker::Number.number(digits: 3) }
    description { Faker::Lorem.sentence }

    association :friend, factory: :user
    association :sender, factory: :user
  end
end