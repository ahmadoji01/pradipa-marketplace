class AddPublishedToBlog < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_blogs, :published, :boolean
  end
end
