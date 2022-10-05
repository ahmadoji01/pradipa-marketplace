class Spree::Collection < ApplicationRecord
  after_update :update_slug
  after_create :create_slug

  mount_uploader :featured_image, CollectionFeaturedImageUploader
  mount_uploader :production_image, CollectionProductionImageUploader
  mount_uploader :summary_image, CollectionSummaryImageUploader
  mount_uploader :banner_image, CollectionBannerImageUploader

  has_many :collection_products
  has_many :products, :class_name => "Spree::Product", through: :collection_products 
  has_many :collection_blogs
  has_many :blogs, :class_name => "Spree::Blog", through: :collection_blogs 

  has_rich_text :collection_description
  has_rich_text :production_description
  has_rich_text :summary_description

  def create_slug
    self.update_columns(slug: generate_slug(self.name))
  end

  def update_slug
    self.update_columns(slug: generate_update_slug(self))
  end

  private

    def generate_slug(name)
      i = 1
      slug = name.parameterize
      while !Spree::Collection.find_by(slug: slug).nil?
        i = i + 1
        slug = name.parameterize + "-" + i.to_s
      end
      return slug
    end

    def generate_update_slug(collection)
      if collection.name_changed?
        i = 1
        slug = collection.name.parameterize
        while !Spree::Collection.find_by(slug: slug).nil?
          i = i + 1
          slug = collection.name.parameterize + "-" + i.to_s
        end  
        return slug
      end
      return collection.name.parameterize
    end

end
