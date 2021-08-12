class AddOrderToWithdrawalBalance < ActiveRecord::Migration[6.1]
  def change
    add_reference :spree_withdrawal_balances, :order
  end
end
