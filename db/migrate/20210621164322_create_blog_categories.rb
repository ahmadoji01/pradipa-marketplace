class CreateBlogCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :blog_categories do |t|
      t.string :name
      t.belongs_to :parent_category, foreign_key: { to_table: :category }
      t.timestamps
    end
  end
end
