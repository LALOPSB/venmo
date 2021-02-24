FactoryBot.define do
  factory :feed_item do
    amount { '100' }
    description { 'This is a payment' }

    association :friend, factory: :user
    association :sender, factory: :user
  end
end