class ChangeSpreeUserToUserOnWithdrawal < ActiveRecord::Migration[6.1]
  def change
    remove_reference :spree_withdrawals, :spree_user
    add_reference :spree_withdrawals, :user
  end
end
