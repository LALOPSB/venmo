FactoryBot.define do
  factory :external_payment_source do
    source_type { 'Bank Account' }

    association :user, factory: :user
  end
end