require 'rails_helper'

RSpec.describe User do
  subject { FactoryBot.build(:user) }
  let!(:user) { FactoryBot.create(:user) }
  let!(:friend) { FactoryBot.create(:user) }

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
    let(:user_original_balance) { 100 }
    let(:friend_original_balance) { 0 }
    let(:payment_amount) { 10 }
    let!(:external_payment_source) { FactoryBot.create(:external_payment_source, user: user) }
    let!(:user_payment_account) { FactoryBot.create(:payment_account, balance: user_original_balance, user: user) }
    let!(:friend_payment_account) { FactoryBot.create(:payment_account, balance: friend_original_balance, user: friend) }

    subject { user.send_payment(friend, payment_amount, payment_description) }

    context 'when the user make a payment to a friend' do
      before { Friendship.create!(user: user, friend: friend) }

      shared_examples 'creates a payment' do
        it 'a payment is created' do
          expect { subject }.to change { Payment.count }.from(0).to(1)

          expect(Payment.first.sender).to eq(user)
          expect(Payment.first.friend).to eq(friend)
          expect(Payment.first.amount).to eq(payment_amount)
          expect(Payment.first.description).to eq(payment_description)
        end
      end

      context 'positive balance' do
        context 'when a user pays an amount lower than the balance' do
          it 'is deducted from their account and added to the friend account' do
            subject

            expect(user_payment_account.balance).to eq(user_original_balance - payment_amount)
            expect(friend_payment_account.balance).to eq(friend_original_balance + payment_amount)
          end

          it_behaves_like 'creates a payment'
        end
      end

      context 'negative balance' do
        let(:payment_amount) { 200 }

        context 'when a user sends an amount larger than its balance' do

          before { allow(user.money_transfer_service).to receive(:transfer).and_call_original }

          it 'the overdraft is transferred from its external money service' do
            expect(user.money_transfer_service).to receive(:transfer).with(100)

            subject

            expect(user_payment_account.balance).to eq(0)
            expect(friend_payment_account.balance).to eq(friend_original_balance + payment_amount)
          end

          it_behaves_like 'creates a payment'
        end

        context 'when the external service fails' do
          before { allow(user.money_transfer_service.external_payment_source).to receive(:send_money).and_raise(Timeout::Error) }

          it 'raises the appropriate error' do
            expect{ subject }.to raise_error(MoneyTransferService::ExternalPaymentServiceError,"The transfer couldn't be completed. Please, try again later.")
          end
        end
      end

      describe 'payment bounds' do
        context 'if the payment is lower than mimimum bound' do
          let(:payment_amount) { -1 }
          it 'raises an error' do
            expect { subject }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Amount must be greater than #{Payment::MINIMUM_PAYMENT_AMOUNT}")
          end
        end

        context 'if the payment is higher than maximum bound' do
          let(:payment_amount) { 1001 }
          it 'raises an error' do
            expect { subject }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Amount must be less than #{Payment::MAXIMUM_PAYMENT_AMOUNT}")
          end
        end
      end
    end

    context 'when the user tries to pay a non friend' do
      it 'raises an error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: #{user.username} you can make payments only to friends.")
      end
    end
  end

  describe 'friends' do
    context 'when a user has a friend' do
      before { Friendship.create!(user: user, friend: friend) }

      it 'they are their friends friend' do
        expect(user.friends).to contain_exactly(friend)
        expect(friend.inverse_friends).to contain_exactly(user)
      end
    end
  end

  describe 'activity feed' do
    include_context 'activity feed'

    context 'build activity feed' do
      let(:expected_non_friend_2_activity_feed) { [pay_between_non_friends_feed_item, pay_non_to_friend_feed_item] }

      it 'returns the activity feed formatted' do
        expect(non_friend_2.activity_feed).to eq(expected_non_friend_2_activity_feed)
      end
    end
  end
end