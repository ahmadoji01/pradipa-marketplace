class ChangeBlogCategoryChildrenType < ActiveRecord::Migration[6.1]
  def change
    add_reference :blog_categories, :parent_category, foreign_key: { to_table: :blog_categories }
  end
end
