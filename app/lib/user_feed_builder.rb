class UserFeedBuilder
  def initialize(user)
    @user = user
  end

  attr_reader :user, :feed_items

  def execute
    feed_items_for_user_and_friends.map do |item|
      "#{item.sender.username} paid #{item.friend.username} on #{item.created_at} - $#{item.amount} - #{item.description}"
    end
  end

  def feed_items_for_user_and_friends
    user_ids = get_all_users_for_activity_feed.map(&:id)
    FeedItem.where('sender_id IN (?) OR friend_id IN (?)', user_ids, user_ids).order_by_created_desc
  end

  def get_all_users_for_activity_feed
    user.friends + user.inverse_friends << user
  end
end
