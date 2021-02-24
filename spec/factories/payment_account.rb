FactoryBot.define do
  factory :payment_account do
    balance { 0 }
    association :user, factory: :user
  end
end