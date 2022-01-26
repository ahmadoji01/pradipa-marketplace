class CreateProducerSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :producer_settings do |t|
      t.string :key
      t.string :value
      t.references :user, foreign_key: { to_table: :spree_users }, null: false

      t.timestamps
    end
  end
end
