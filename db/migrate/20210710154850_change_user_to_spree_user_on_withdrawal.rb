class ChangeUserToSpreeUserOnWithdrawal < ActiveRecord::Migration[6.1]
  def change
    remove_reference :spree_withdrawals, :user
    add_reference :spree_withdrawals, :spree_user
  end
end
