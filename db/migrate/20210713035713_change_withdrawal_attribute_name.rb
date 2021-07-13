class ChangeWithdrawalAttributeName < ActiveRecord::Migration[6.1]
  def change
    remove_reference :spree_withdrawal_requests, :spree_withdrawal
    remove_index :spree_withdrawal_requests, :withdrawal_id 
    add_reference :spree_withdrawal_requests, :withdrawal, foreign_key: { to_table: :spree_withdrawals }
  end
end
