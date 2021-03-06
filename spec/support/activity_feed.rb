RSpec.shared_context 'activity feed' do
  let!(:user) { FactoryBot.create(:user) }
  let!(:friend) { FactoryBot.create(:user) }

  let(:friend_1) { FactoryBot.create(:user) }
  let(:friend_2) { FactoryBot.create(:user) }
  let(:non_friend_1) { FactoryBot.create(:user) }
  let(:non_friend_2) { FactoryBot.create(:user) }
  let(:user_feed_builder) { described_class.new(user) }

  before do
    Friendship.create!(user: user, friend: friend_1)
    Friendship.create!(user: friend_1, friend: friend_2)
    Friendship.create!(user: friend_2, friend: user)
    Friendship.create!(user: non_friend_2, friend: non_friend_1)
    Friendship.create!(user: friend_2, friend: non_friend_1)
  end

  let!(:pay_to_friend) { FactoryBot.create(:payment, sender: user, friend: friend_1, amount: 80, description: 'Payment to friend', created_at: 1.week.ago) }
  let!(:pay_between_friends) { FactoryBot.create(:payment, sender: friend_1, friend: friend_2, amount: 15, description: 'Payment between friends', created_at: 1.hour.from_now) }
  let!(:pay_between_non_friends) { FactoryBot.create(:payment, sender: non_friend_1, friend: non_friend_2, amount: 23, description: 'Payment between non friends', created_at: 15.minutes.from_now) }
  let!(:pay_non_to_friend) { FactoryBot.create(:payment, sender: non_friend_1, friend: friend_2, amount: 55, description: 'Payment from non friend to friend') }
  let!(:pay_from_friend) { FactoryBot.create(:payment, sender: friend_1, friend: user, amount: 108, description: 'Payment from friend', created_at: 2.days.ago) }

  let(:friends_activity) { [pay_to_friend, pay_between_friends, pay_non_to_friend, pay_from_friend] }

  let(:pay_between_friends_feed_item) do
    {
      title: "#{friend_1.username} paid #{friend_2.username} on #{pay_between_friends.created_at} - #{pay_between_friends.description}",
      amount: "$#{pay_between_friends.amount}",
      description: pay_between_friends.description,
    }
  end

  let(:pay_non_to_friend_feed_item) do
    {
      title: "#{non_friend_1.username} paid #{friend_2.username} on #{pay_non_to_friend.created_at} - #{pay_non_to_friend.description}",
      amount: "$#{pay_non_to_friend.amount}",
      description: pay_non_to_friend.description,
    }
  end
  let(:pay_from_friend_feed_item) do
    {
      title: "#{friend_1.username} paid #{user.username} on #{pay_from_friend.created_at} - #{pay_from_friend.description}",
      amount: "$#{pay_from_friend.amount}",
      description: pay_from_friend.description,
    }
  end
  let(:pay_to_friend_feed_item) do
    {
      title: "#{user.username} paid #{friend_1.username} on #{pay_to_friend.created_at} - #{pay_to_friend.description}",
      amount: "$#{pay_to_friend.amount}",
      description: pay_to_friend.description,
    }
  end
  let(:pay_between_non_friends_feed_item) do
    {
      title: "#{non_friend_1.username} paid #{non_friend_2.username} on #{pay_between_non_friends.created_at} - #{pay_between_non_friends.description}",
      amount: "$#{pay_between_non_friends.amount}",
      description: pay_between_non_friends.description,
    }
  end
end