require 'rails_helper'

RSpec.describe PaymentAccount do
  subject { FactoryBot.build(:payment_account) }

  describe 'validation' do
    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_uniqueness_of :user }
    it { is_expected.to validate_presence_of :balance }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
