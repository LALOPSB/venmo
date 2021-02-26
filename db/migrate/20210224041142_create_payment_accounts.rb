class CreatePaymentAccounts < ActiveRecord::Migration
  def change
    create_table :payment_accounts do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.float :balance, null: false, default: 0
      t.timestamps null: false
    end
  end
end
