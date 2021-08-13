class AddOrderToWithdrawalBalance < ActiveRecord::Migration[6.1]
  def change
    remove_reference :spree_withdrawal_balances, :order
    add_reference :spree_withdrawal_balances, :order, foreign_key: { to_table: :spree_orders }
  end
end
