require 'rails_helper'

RSpec.describe Payment do
  subject{ FactoryBot.build(:payment) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:sender_id) }
    it { is_expected.to validate_presence_of(:friend_id) }
    it { is_expected.to validate_presence_of(:amount) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:sender).class_name('User') }
    it { is_expected.to belong_to(:friend).class_name('User') }
  end
end