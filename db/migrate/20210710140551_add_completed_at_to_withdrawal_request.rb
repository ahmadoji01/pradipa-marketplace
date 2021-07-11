class AddCompletedAtToWithdrawalRequest < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_withdrawal_requests, :completed_at, :datetime
  end
end
