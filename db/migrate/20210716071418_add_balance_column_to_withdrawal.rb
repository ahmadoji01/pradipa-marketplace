class AddBalanceColumnToWithdrawal < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_withdrawals, :balance, :decimal, precision: 10, scale: 2
  end
end
