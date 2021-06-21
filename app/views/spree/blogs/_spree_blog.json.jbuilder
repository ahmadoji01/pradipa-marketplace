json.extract! spree_blog, :id, :title, :body, :meta_title, :meta_keyword, :subtitle, :featured_image, :edited_at, :category, :created_at, :updated_at
json.url spree_blog_url(spree_blog, format: :json)
