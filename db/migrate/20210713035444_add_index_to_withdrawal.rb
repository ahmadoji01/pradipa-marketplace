class AddIndexToWithdrawal < ActiveRecord::Migration[6.1]
  def change
    add_index :spree_withdrawal_requests, :withdrawal_id 
  end
end
