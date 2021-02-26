class RenameFeedItemToPayment < ActiveRecord::Migration
  def change
    rename_table :feed_items, :payments
  end
end
