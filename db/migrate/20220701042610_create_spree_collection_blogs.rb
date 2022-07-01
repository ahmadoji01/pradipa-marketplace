class CreateSpreeCollectionBlogs < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_collection_blogs do |t|
      t.references :collection, foreign_key: { to_table: :spree_collections }
      t.references :blog, foreign_key: { to_table: :spree_blogs }
      t.timestamps
    end
  end
end
