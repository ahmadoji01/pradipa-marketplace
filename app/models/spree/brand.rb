class Spree::Brand < ApplicationRecord
  mount_uploader :brand_banner, BrandBannerUploader
  mount_uploader :brand_photo, BrandPhotoUploader
  belongs_to :user
end
