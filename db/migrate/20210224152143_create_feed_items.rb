class CreateFeedItems < ActiveRecord::Migration
  def change
    create_table :feed_items do |t|
      t.references :sender, index: true, null: false
      t.references :friend, index: true, null: false
      t.integer :amount, null: false
      t.string :description

      t.timestamps null: false
    end
  end
end
