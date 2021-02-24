class User < ActiveRecord::Base
  validates_presence_of :username
  validates_uniqueness_of :username

  has_one :payment_account
  has_one :external_payment_source

  has_many :friendships
  has_many :friends, through: :friendships, foreign_key: 'user_id'
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user

  attr_reader :money_transfer_service

  MINIMUM_PAYMENT_AMOUNT = 0
  MAXIMUM_PAYMENT_AMOUNT = 1000

  NonFriendPaymentAttempt = Class.new(StandardError)
  PaymentAmountOutOfBounds = Class.new(StandardError)

  def send_payment(friend, payment_amount, description)
    raise NonFriendPaymentAttempt, 'You can make payments only to befriended users' unless is_friend?(friend)
    raise PaymentAmountOutOfBounds, "Payment amount should be between #{MINIMUM_PAYMENT_AMOUNT} and #{MAXIMUM_PAYMENT_AMOUNT}" unless within_bounds?(payment_amount)

    ActiveRecord::Base.transaction do
      payment_account.withdraw(payment_amount)
      friend.payment_account.deposit(payment_amount)

      FeedItem.create!(friend: friend, sender: self, amount: payment_amount, description: description)
    end
  end

  def money_transfer_service
    @money_transfer_service ||= MoneyTransferService.new(external_payment_source, payment_account)
  end

  private

  def is_friend?(user)
    friends.include?(user) || inverse_friends.include?(user)
  end

  def within_bounds?(payment_amount)
    payment_amount.between?(MINIMUM_PAYMENT_AMOUNT, MAXIMUM_PAYMENT_AMOUNT)
  end
end