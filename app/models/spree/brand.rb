class Spree::Brand < ApplicationRecord
  after_save :create_slug

  mount_uploader :brand_banner, BrandBannerUploader
  mount_uploader :brand_photo, BrandPhotoUploader
  belongs_to :user

  def create_slug
    self.update_columns(slug: generate_slug(self.name))
  end

  private
    def generate_slug(name)
      i = 1
      slug = name.parameterize
      while !Spree::Brand.find_by(slug: slug).nil?
          i = i + 1
          slug = name.parameterize + "-" + i.to_s
      end
      return slug
    end
    
end
