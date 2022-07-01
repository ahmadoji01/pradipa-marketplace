class Spree::CollectionBlog < ApplicationRecord

    belongs_to :collection, :class_name => "Spree::Collection"
    belongs_to :blog, :class_name => "Spree::Blog"

end
