require 'rails_helper'

RSpec.describe 'users endpoints', type: :request do
  let(:json_body) { JSON.parse(response.body).deep_symbolize_keys }
  let(:user) { FactoryBot.create(:user) }
  let(:user_id) { user.id }
  let(:friend) { FactoryBot.create(:user) }
  let(:amount) { 100 }
  let(:description) { 'This is a payment' }
  let!(:user_account) { FactoryBot.create(:payment_account, balance: 130, user: user) }
  let!(:friend_account) { FactoryBot.create(:payment_account, balance: 180, user: friend) }

  shared_examples 'raises user not found error for non existent user' do
    context 'non existent user' do
      let(:user_id) { 9999 }

      it 'returns a not found error' do
        subject

        expect(response.status).to eq(404)
        expect(json_body).to eq({ error: 'User not found!'})
      end
    end
  end

  describe 'POST payment' do
    subject(:send_payment) { post "/user/#{user_id}/payment?friend_id=#{friend.id}&amount=#{amount}&description=#{description}" }

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
              expect(json_body).to eq({ error: 'Validation failed: Amount must be less than 1000.0' })
            end
          end
        end

        context 'to a non friend' do
          it 'returns an error' do
            send_payment

            expect(response.status).to eq(400)
            expect(json_body).to eq({ error: "Validation failed: #{user.username} you can make payments only to friends." })
          end
        end
      end

    it_behaves_like 'raises user not found error for non existent user'
  end

  describe 'GET balance' do
    subject(:get_balance_check) { get "/user/#{user_id}/balance" }

    it 'returns a successful response and sends payment' do
      get_balance_check

      expect(response.status).to eq(200)
      expect(json_body).to eq({ balance_check: 130 })
    end

    it_behaves_like 'raises user not found error for non existent user'
  end

  describe 'GET feed' do
    include_context 'activity feed'

    subject(:get_feed) { get "/user/#{user_id}/feed" }

    let(:expected_user_activity_feed) do
      [
        pay_between_friends_title_and_desc,
        pay_non_to_friend_title_and_desc,
        pay_from_friend_title_and_desc,
        pay_to_friend_title_and_desc
      ]
    end

    it 'returns a successful response and sends payment' do
      get_feed

      expect(response.status).to eq(200)
      expect(json_body).to eq({ activity_feed: expected_user_activity_feed })
    end

    context 'pagination' do
      before { stub_const("#{UserFeedBuilder}::DEFAULT_PER_PAGE_ITEMS", 3) }

      let(:expected_user_activity_feed_page_2) { [pay_to_friend_title_and_desc] }
      let(:page) { 2 }

      it 'returns items for the page provided' do
        get "/user/#{user_id}/feed?page=#{page}"

        expect(json_body).to eq({ activity_feed: expected_user_activity_feed_page_2 })
      end
    end

    it_behaves_like 'raises user not found error for non existent user'
  end
end