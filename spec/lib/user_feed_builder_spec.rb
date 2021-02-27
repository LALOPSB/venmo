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
        pay_between_friends_feed_item,
        pay_non_to_friend_feed_item,
        pay_from_friend_feed_item,
        pay_to_friend_feed_item
      ]
    end
    let(:user_feed_builder) { described_class.new(user) }

    it 'returns the activity feed formatted and in reverse chonological order' do
      expect(user_feed_builder.execute).to eq(expected_user_activity_feed)
    end

    describe 'pagination' do
      before { stub_const("UserFeedBuilder::DEFAULT_PER_PAGE_ITEMS", 3) }

      let(:user_feed_builder) { described_class.new(user, 2) }

      let(:expected_user_activity_feed_page_1) do
        [
          pay_between_friends_feed_item,
          pay_non_to_friend_feed_item,
          pay_from_friend_feed_item
        ]
      end
      let(:expected_user_activity_feed_page_2) { [pay_to_friend_feed_item] }

      it 'returns items paginated' do
        expect(described_class.new(user, 1).execute).to eq(expected_user_activity_feed_page_1)
        expect(described_class.new(user, 2).execute).to eq(expected_user_activity_feed_page_2)
      end
    end
  end
end
