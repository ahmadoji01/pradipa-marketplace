class Spree::Brand < ApplicationRecord
  after_update :update_slug
  after_save :create_slug

  mount_uploader :brand_banner, BrandBannerUploader
  mount_uploader :brand_photo, BrandPhotoUploader
  belongs_to :user

  def create_slug
    self.update_columns(slug: generate_slug(self.name))
  end

  def update_slug
    self.update_columns(slug: generate_update_slug(self.name, self.id))
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

    def generate_update_slug(name, id)
      brand = Spree::Brand.find(id)
      if brand.name != name
        i = 1
        slug = name.parameterize
        while !Spree::Brand.find_by(slug: slug).nil?
          i = i + 1
          slug = name.parameterize + "-" + i.to_s
        end  
        return slug
      end
      return name.parameterize
    end
    
end
