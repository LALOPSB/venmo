class ExternalPaymentSource < ActiveRecord::Base
  validates :user, :source_type, presence: true
  validates :user, uniqueness: true

  belongs_to :user

  def send_money(amount)
    true
  end
end