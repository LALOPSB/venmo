class UserFeedBuilder
  def initialize(user, page = DEFAULT_PAGE)
    @user = user
    @page = page
  end

  DEFAULT_PER_PAGE_ITEMS = 10
  DEFAULT_PAGE = 1

  attr_reader :user, :feed_items, :page, :per_page

  def execute
    feed_items_for_user_and_friends.map do |item|
      "#{item.sender.username} paid #{item.friend.username} on #{item.created_at} - $#{item.amount} - #{item.description}"
    end
  end

  def feed_items_for_user_and_friends
    user_ids = get_all_users_for_activity_feed.map(&:id)
    Payment.where('sender_id IN (?) OR friend_id IN (?)', user_ids, user_ids).order_by_created_desc.page(page).per_page(DEFAULT_PER_PAGE_ITEMS)
  end

  def get_all_users_for_activity_feed
    user.friends + user.inverse_friends << user
  end
end
