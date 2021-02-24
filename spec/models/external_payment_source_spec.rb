require 'rails_helper'

RSpec.describe ExternalPaymentSource do
  subject { FactoryBot.build(:external_payment_source) }

  describe 'validation' do
    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_uniqueness_of :user }
    it { is_expected.to validate_presence_of :type }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
