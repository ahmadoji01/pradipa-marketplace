class CreateSpreeCollections < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_collections do |t|
      t.string :name
      t.string :slug
      t.string :meta_description
      t.string :meta_keywords
      t.string :meta_tags
      t.string :featured_video
      t.string :featured_image
      t.string :collection_description
      t.references :product, foreign_key: { to_table: :spree_products }, null: false
      t.references :blog, foreign_key: { to_table: :spree_blogs }
      t.string :production_image
      t.string :production_description
      t.string :production_video
      t.string :description
      t.boolean :published
      t.timestamps
    end
  end
end
