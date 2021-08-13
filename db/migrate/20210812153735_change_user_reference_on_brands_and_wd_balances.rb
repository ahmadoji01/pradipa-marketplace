class ChangeUserReferenceOnBrandsAndWdBalances < ActiveRecord::Migration[6.1]
  def change
    remove_reference :spree_withdrawal_balances, :user
    remove_reference :spree_brands, :user
    add_reference :spree_withdrawal_balances, :user, foreign_key: { to_table: :spree_users }
    add_reference :spree_brands, :user, foreign_key: { to_table: :spree_users }
  end
end
