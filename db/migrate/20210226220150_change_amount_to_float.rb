class ChangeAmountToFloat < ActiveRecord::Migration
  def up
    change_column :payments, :amount, :float
  end

  def down
    change_column :payments, :amount, :integer
  end
end
