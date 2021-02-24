class PaymentAccount < ActiveRecord::Base
  validates_presence_of :user
  validates_presence_of :balance
  validates_uniqueness_of :user

  belongs_to :user

  def withdraw(amount)
    @amount = amount
    transfer_amount_from_external_service if overdrawn?
    update!(balance: balance - amount)
  end

  def deposit(amount)
    update!(balance: balance + amount)
  end

  attr_reader :amount

  private

  def overdrawn?
    balance < amount
  end

  def transfer_amount_from_external_service
    user.money_transfer_service.transfer(amount - balance)
  end
end