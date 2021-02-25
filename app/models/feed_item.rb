class FeedItem < ActiveRecord::Base
  validates_presence_of :sender_id
  validates_presence_of :friend_id
  validates_presence_of :amount

  belongs_to :friend, class_name: 'User', foreign_key: :friend_id
  belongs_to :sender, class_name: 'User', foreign_key: :sender_id

  scope :order_by_created_desc, -> { order(created_at: :desc) }
end