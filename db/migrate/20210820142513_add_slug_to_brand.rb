class AddSlugToBrand < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_brands, :slug, :string
  end
end
