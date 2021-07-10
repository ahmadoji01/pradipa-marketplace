class ChangeUserNameInProductTable < ActiveRecord::Migration[6.1]
  def change
    remove_reference :spree_products, :spree_user
    add_reference :spree_products, :producer, foreign_key: { to_table: :spree_users }
  end
end
