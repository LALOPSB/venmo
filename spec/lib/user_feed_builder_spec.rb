require 'rails_helper'

RSpec.describe UserFeedBuilder do
  include_context 'activity feed'

  describe '#get_all_users_for_activity_feed' do
    it 'returns both friends and inverse_friends' do
      expect(user_feed_builder.get_all_users_for_activity_feed).to contain_exactly(friend_1, friend_2, user)
    end
  end

  describe '#feed_items_for_user_and_friends' do
    it "returns the their own feed items and its friends' as a list" do
      expect(user_feed_builder.feed_items_for_user_and_friends).to match_array(friends_activity)
    end
  end

  describe '#execute' do
    let(:expected_user_activity_feed) do
      [
        "#{friend_1.username} paid #{friend_2.username} on #{pay_between_friends.created_at} - $15 - Payment between friends",
        "#{non_friend_1.username} paid #{friend_2.username} on #{pay_non_to_friend.created_at} - $55 - Payment from non friend to friend",
        "#{friend_1.username} paid #{user.username} on #{pay_from_friend.created_at} - $108 - Payment from friend",
        "#{user.username} paid #{friend_1.username} on #{pay_to_friend.created_at} - $80 - Payment to friend"
      ]
    end
    let(:user_feed_builder) { described_class.new(user) }

    it 'returns the activity feed formatted and in reverse chonological order' do
      expect(user_feed_builder.execute).to eq(expected_user_activity_feed)
    end
  end
end
