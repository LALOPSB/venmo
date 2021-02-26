class User < ActiveRecord::Base
  validates :username, presence: true
  validates :username, uniqueness: true

  has_one :payment_account
  has_one :external_payment_source

  has_many :friendships
  has_many :friends, through: :friendships, foreign_key: 'user_id'
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  attr_reader :money_transfer_service

  def send_payment(friend, payment_amount, description)
    ActiveRecord::Base.transaction do
      payment_account.withdraw(payment_amount)
      friend.payment_account.deposit(payment_amount)

      Payment.create!(friend: friend, sender: self, amount: payment_amount, description: description)
    end
  end

  def money_transfer_service
    @money_transfer_service ||= MoneyTransferService.new(external_payment_source, payment_account)
  end

  def activity_feed
    UserFeedBuilder.new(self).execute
  end
end