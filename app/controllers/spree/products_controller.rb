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

            @searcher = build_searcher(params.merge(taxon: @product.taxon_ids.first))
            @relatedproducts = @searcher.retrieve_products
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
                return products.sort{|a| a.price}
            elsif sort == "price-desc"
                return products.sort{|a,b| b.price <=> a.price}
            elsif sort == "latest"
                return products.sort{|a,b| b.created_at <=> a.created_at}
            end

            return products
        end
    end
end  