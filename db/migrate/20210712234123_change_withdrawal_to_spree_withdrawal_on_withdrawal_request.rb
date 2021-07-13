class ChangeWithdrawalToSpreeWithdrawalOnWithdrawalRequest < ActiveRecord::Migration[6.1]
  def change
    remove_reference :spree_withdrawal_requests, :withdrawal
    add_reference :spree_withdrawal_requests, :spree_withdrawal, index: true
  end
end
