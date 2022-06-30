class Spree::Collection < ApplicationRecord
  after_save :create_slug

  mount_uploader :featured_image, CollectionFeaturedImageUploader
  mount_uploader :production_image, CollectionProductionImageUploader

  has_many :products
  has_many :blogs

  has_rich_text :description
  has_rich_text :production_description

  def create_slug
    self.update_columns(slug: generate_slug(self.name))
  end

  private

    def generate_slug(title)
      i = 1
      slug = title.parameterize
      while !Spree::Collection.find_by(slug: slug).nil?
        i = i + 1
        slug = title.parameterize + "-" + i.to_s
      end
      return slug
    end

end
