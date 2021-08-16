class CreateOrderNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :order_notifications do |t|
      t.string :title
      t.string :notif_type
      t.boolean :read
      t.references :user, foreign_key: { to_table: :spree_users }
      t.references :order, foreign_key: { to_table: :spree_orders }

      t.timestamps
    end
  end
end
