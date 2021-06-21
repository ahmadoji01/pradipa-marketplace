class CreateSpreeBlogs < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_blogs do |t|
      t.string :title
      t.string :body
      t.string :meta_title
      t.string :meta_keyword
      t.string :subtitle
      t.string :featured_image
      t.timestamp :edited_at
      t.references :blog_category

      t.timestamps
    end
  end
end
