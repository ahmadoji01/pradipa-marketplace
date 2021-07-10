class AddUserToProducts < ActiveRecord::Migration[6.1]
  def change
    add_reference :spree_products, :user, index: true
  end
end
