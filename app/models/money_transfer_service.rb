class MoneyTransferService
  attr_reader :external_payment_source, :user_payment_account

  class ExternalPaymentServiceError < ::StandardError; end

  def initialize(external_payment_source, user_payment_account)
    @external_payment_source = external_payment_source
    @user_payment_account = user_payment_account
  end

  def transfer(amount)
    ActiveRecord::Base.transaction do
      external_payment_source.try(:send_money, amount)
      user_payment_account.try(:deposit, amount)
    end

    true
  rescue => e
    raise ExternalPaymentServiceError, "The transfer couldn't be completed. Please, try again later."
  end
end
