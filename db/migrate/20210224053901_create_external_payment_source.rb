class CreateExternalPaymentSource < ActiveRecord::Migration
  def change
    create_table :external_payment_sources do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.string :type, null: false

      t.timestamps null: false
    end
  end
end
