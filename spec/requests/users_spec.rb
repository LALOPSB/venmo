require 'rails_helper'

RSpec.describe 'users endpoints', type: :request do
  let(:json_body) { JSON.parse(response.body).deep_symbolize_keys }
  let(:user) { FactoryBot.create(:user) }
  let(:friend) { FactoryBot.create(:user) }
  let(:amount) { 100 }
  let(:description) { 'This is a payment' }
  let!(:user_account) { FactoryBot.create(:payment_account, balance: 130, user: user) }
  let!(:friend_account) { FactoryBot.create(:payment_account, balance: 180, user: friend) }

  describe 'POST payment' do
    subject(:send_payment) { post "/user/#{user.id}/payment?friend_id=#{friend.id}&amount=#{amount}&description=#{description}" }

    context 'when a user sends a payment' do

      context 'to a friend' do
        before { Friendship.create!(user: user, friend: friend) }

        context 'with an amount within bounds' do
          it 'returns a successful response and sends payment' do
            send_payment

            expect(response.status).to eq(200)
            expect(json_body).to eq({})
            expect(user_account.reload.balance).to eq(30)
            expect(friend_account.reload.balance).to eq(280)
          end
        end

        context 'with an amount outside bounds' do
          let(:amount) { 1001 }

          it 'returns an error' do
            send_payment

            expect(response.status).to eq(400)
            expect(json_body).to eq({ error: 'Payment amount should be between 0 and 1000' })
          end
        end
      end

      context 'to a non friend' do
        it 'returns an error' do
          send_payment

          expect(response.status).to eq(400)
          expect(json_body).to eq({ error: 'You can make payments only to befriended users' })
        end
      end
    end
  end

  describe 'GET balance' do
    subject(:get_balance_check) { get "/user/#{user.id}/balance" }

    it 'returns a successful response and sends payment' do
      get_balance_check

      expect(response.status).to eq(200)
      expect(json_body).to eq({ balance_check: 130 })
    end
  end
end