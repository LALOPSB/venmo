class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.references :user, index: true, null: false
      t.references :friend, index: true, null: false
    end
  end
end
