class Spree::Blog < ApplicationRecord
    after_save :create_slug
    
    mount_uploader :featured_image, BlogFeaturedImageUploader
    belongs_to :blog_category, optional: true
    has_rich_text :body

    def create_slug
        self.update_columns(slug: generate_slug(self.title))
    end

    private

        def generate_slug(title)
            i = 1
            slug = title.parameterize
            while !Spree::Blog.find_by(slug: slug).nil?
                i = i + 1
                slug = title.parameterize + "-" + i.to_s
            end
            return slug
        end
end
