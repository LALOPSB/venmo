class PaymentAccount < ActiveRecord::Base
  validates :user, :balance, presence: true
  validates :user, uniqueness: true

  belongs_to :user

  class PaymentError < ::StandardError; end

  def withdraw(amount)
    ActiveRecord::Base.transaction do
      transfer_amount_from_external_service(amount) if overdrawn?(amount)
      update!(balance: balance - amount)
    end
  end

  def deposit(amount)
    update!(balance: balance + amount)
  end

  private

  def overdrawn?(amount)
    balance < amount
  end

  def transfer_amount_from_external_service(amount)
    user.money_transfer_service.transfer(amount - balance)
  end
end