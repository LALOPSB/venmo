FactoryBot.define do
  factory :external_payment_source do
    type { 'bank_account' }
    association :user, factory: :user
  end
end