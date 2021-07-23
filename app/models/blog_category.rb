class BlogCategory < ApplicationRecord
    has_many :blogs
    has_many :subcategories, :class_name => "BlogCategory", :foreign_key => "parent_id"
    belongs_to :parent_category, :class_name => "BlogCategory", :optional => true
end
