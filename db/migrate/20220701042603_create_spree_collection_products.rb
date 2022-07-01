class CreateSpreeCollectionProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_collection_products do |t|
      t.references :collection, foreign_key: { to_table: :spree_collections }
      t.references :product, foreign_key: { to_table: :spree_products }
      t.timestamps
    end
  end
end
