class Spree::CollectionProduct < ApplicationRecord

    belongs_to :collection, :class_name => "Spree::Collection"
    belongs_to :product, :class_name => "Spree::Product"   

end
