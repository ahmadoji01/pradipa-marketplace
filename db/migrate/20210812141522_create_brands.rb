class CreateBrands < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_brands do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :description
      t.string :brand_banner
      t.string :brand_photo

      t.timestamps
    end
  end
end
