class Payment < ActiveRecord::Base
  MINIMUM_PAYMENT_AMOUNT = 0.00
  MAXIMUM_PAYMENT_AMOUNT = 1000.00

  validates :sender_id, :friend_id, :amount, presence: true
  validates :amount, numericality: { greater_than: MINIMUM_PAYMENT_AMOUNT, less_than: MAXIMUM_PAYMENT_AMOUNT }
  validate :is_friend

  belongs_to :friend, class_name: 'User', foreign_key: :friend_id
  belongs_to :sender, class_name: 'User', foreign_key: :sender_id

  scope :order_by_created_desc, -> { order(created_at: :desc) }

  private

  def is_friend
    unless (sender.friends.include?(friend) || sender.inverse_friends.include?(friend))
      errors.add(sender.username, 'you can make payments only to friends.')
    end
  end
end