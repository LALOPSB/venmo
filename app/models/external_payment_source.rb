class ExternalPaymentSource < ActiveRecord::Base
  validates_presence_of :user
  validates_presence_of :type
  validates_uniqueness_of :user

  belongs_to :user
end