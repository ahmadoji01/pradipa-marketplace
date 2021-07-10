class ChangeProducerToUserInProduct < ActiveRecord::Migration[6.1]
  def change
    remove_reference :spree_products, :producer
    add_reference :spree_products, :user
  end
end
