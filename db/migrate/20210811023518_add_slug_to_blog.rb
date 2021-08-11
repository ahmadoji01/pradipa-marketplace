class AddSlugToBlog < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_blogs, :slug, :string
  end
end
