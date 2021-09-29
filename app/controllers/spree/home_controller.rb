module Spree
  class HomeController < Spree::StoreController
    helper 'spree/products'
    respond_to :html

    def index
      @searcher = build_searcher(params.merge(include_images: true))
      @products = @searcher.retrieve_products
      @taxonomies = Spree::Taxonomy.includes(root: :children)
      @categories = Spree::Taxon.find_by(name: "Categories").children
      @featured_products = @products.order("created_at DESC").slice(0,5)
      @recent_products = @products.order("created_at DESC").slice(0,8)
      @recent_posts = Spree::Blog.last(5)
    end

    def brand
      @brand = Spree::Brand.find_by(slug: params[:slug])
      @products = Spree::Product.where(user_id: @brand.user.id)
    end
  end
end