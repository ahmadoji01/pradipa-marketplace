class AddHandlingFeeToWithdrawalBalance < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_withdrawal_balances, :handling_fee, :decimal
  end
end
