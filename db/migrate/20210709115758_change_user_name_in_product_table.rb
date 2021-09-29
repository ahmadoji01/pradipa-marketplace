class ChangeUserNameInProductTable < ActiveRecord::Migration[6.1]
  def change
    add_reference :spree_products, :user, foreign_key: { to_table: :spree_users }
  end
end
