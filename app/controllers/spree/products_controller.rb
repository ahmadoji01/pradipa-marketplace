# frozen_string_literal: true

module Spree
    class ProductsController < Spree::StoreController
        before_action :load_product, only: :show
        before_action :load_taxon, only: :index

        helper 'spree/taxons', 'spree/taxon_filters'

        respond_to :html

        def index
            @searcher = build_searcher(params.merge(include_images: true))
            @products = @searcher.retrieve_products
            @products = sort_products(@products)

            if !params[:tag].nil?
              @products = @products.in_keywords(params[:tag])
            end

            if !params[:pricefrom].nil? && !params[:priceto].nil?
              @products = @products.price_between(params[:pricefrom], params[:priceto])
            end

            @total = @products.total_count
            @taxonomies = Spree::Taxonomy.includes(root: :children)
        end

        def show
            @variants = @product.
                variants_including_master.
                display_includes.
                with_prices(current_pricing_options).
                includes([:option_values, :images])

            @product_properties = @product.product_properties.includes(:property)
            @taxon = Spree::Taxon.find(params[:taxon_id]) if params[:taxon_id]

            @brand = Spree::Brand.where(user_id: -1)
            if !@product.user.nil?
                @brand = Spree::Brand.where(user_id: @product.user.id)
            end

            @searcher = build_searcher(params.merge(taxon: @product.taxon_ids.first))
            @relatedproducts = @searcher.retrieve_products
            @tags = @product.meta_keywords.nil? ? [] : @product.meta_keywords.split(", ")
        end

        private

        def accurate_title
            if @product
                @product.meta_title.blank? ? @product.name : @product.meta_title
            else
                super
            end
        end

        def load_product
            if try_spree_current_user.try(:has_spree_role?, "admin")
                @products = Spree::Product.with_discarded
            else
                @products = Spree::Product.available
            end
            @product = @products.friendly.find(params[:id])
        end

        def load_taxon
            @taxon = Spree::Taxon.find(params[:taxon]) if params[:taxon].present?
        end

        def sort_products(products)
            sort = params[:sort].present? ? params[:sort] : ""

            if sort == "price"
                return products.ascend_by_master_price
            elsif sort == "price-desc"
                return products.descend_by_master_price
            elsif sort == "latest"
                return products.descend_by_updated_at
            end

            return products
        end
    end
end  