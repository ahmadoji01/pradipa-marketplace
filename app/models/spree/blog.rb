class Spree::Blog < ApplicationRecord
    mount_uploader :featured_image, BlogFeaturedImageUploader
    belongs_to :blog_category, optional: true
    has_rich_text :body
end
