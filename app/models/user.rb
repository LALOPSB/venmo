class User < ActiveRecord::Base
  validates_presence_of :username
  validates_uniqueness_of :username

  has_one :payment_account
  has_one :external_payment_source

  attr_reader :money_transfer_service

  def send_payment(friend, payment_amount, description)
    ActiveRecord::Base.transaction do
      payment_account.withdraw(payment_amount)
      friend.payment_account.deposit(payment_amount)

      FeedItem.create!(friend: friend, sender: self, amount: payment_amount, description: description)
    end
  end

  def money_transfer_service
    @money_transfer_service ||= MoneyTransferService.new(external_payment_source, payment_account)
  end
end