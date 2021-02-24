require 'rails_helper'

RSpec.describe User do
  subject { FactoryBot.build(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:username) }
  end

  describe 'associations' do
    it { is_expected.to have_one(:payment_account) }
    it { is_expected.to have_one(:external_payment_source) }
  end

  describe 'payments' do
    let(:payment_description) { 'This is a payment' }
    let!(:user) { FactoryBot.create(:user) }
    let!(:friend) { FactoryBot.create(:user) }
    let(:user_original_balance) { 100 }
    let(:friend_original_balance) { 0 }
    let!(:user_payment_account) { FactoryBot.create(:payment_account, balance: user_original_balance, user: user) }
    let!(:friend_payment_account) { FactoryBot.create(:payment_account, balance: friend_original_balance, user: friend) }

    subject{ user.send_payment(friend, payment_amount, payment_description) }

    shared_examples 'creates an item feed' do
      it 'a feed item is created' do
        expect{subject}.to change{FeedItem.count}.from(0).to(1)

        expect(FeedItem.first.sender).to eq(user)
        expect(FeedItem.first.friend).to eq(friend)
        expect(FeedItem.first.amount).to eq(payment_amount)
        expect(FeedItem.first.description).to eq(payment_description)
      end
    end

    context 'positive balance' do
      context 'when a user pays an amount lower than the balance' do
        let(:payment_amount) { 10 }

        it 'is deducted from their account and added to the friend account' do
          subject

          expect(user_payment_account.balance).to eq(user_original_balance - payment_amount)
          expect(friend_payment_account.balance).to eq(friend_original_balance + payment_amount)
        end

        it_behaves_like 'creates an item feed'
      end
    end

    context 'negative balance' do
      context 'when a user sends an amount larger than its balance' do
        let(:payment_amount) { 200 }

        before { allow(user.money_transfer_service).to receive(:transfer).and_call_original }

        it 'the overdraft is transferred from its external money service' do
          expect(user.money_transfer_service).to receive(:transfer).with(100)

          subject

          expect(user_payment_account.balance).to eq(0)
          expect(friend_payment_account.balance).to eq(friend_original_balance + payment_amount)
        end

        it_behaves_like 'creates an item feed'
      end
    end
  end
end