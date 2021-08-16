class OrderNotification < ApplicationRecord
    belongs_to :user, :class_name => "Spree::User", :optional => true
    belongs_to :order, :class_name => "Spree::Order", :optional => true
end