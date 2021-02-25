FactoryBot.define do
  factory :payment_account do
    balance { 100 }
    association :user, factory: :user
  end
end