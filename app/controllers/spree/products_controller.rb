# frozen_string_literal: true

module Spree
    class ProductsController < Spree::StoreController
        before_action :load_product, only: :show
        before_action :load_taxon, only: :index

        helper 'spree/taxons', 'spree/taxon_filters'
        helper Rails.application.routes.url_helpers

        respond_to :html

        def index
            @searcher = build_searcher(params.merge(include_images: true))
            @products = @searcher.retrieve_products
            @total = @products.total_count
            @products = sort_products(@products)
            @taxonomies = Spree::Taxonomy.includes(root: :children)
        end

        def shop
            params[:q] ||= {}
            params[:q] = build_search_params(params)
            @p = set_searched_object(params)

            @q = @p.accessible_by(current_ability, :index).ransack(params[:q])
            @products = @q.result(distinct: true).
                page(params[:page]).
                per(params[:per_page] || Spree::Config[:orders_per_page])
            @products = sort_products(@products)
            @total = @q.result(distinct: true).count
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
            if !@product.producer.nil?
                @brand = Spree::Brand.where(user_id: @product.producer.id)
            end

            @searcher = build_searcher(params.merge(taxon: @product.taxon_ids.first))
            @relatedproducts = @searcher.retrieve_products
        end

        private

        def set_searched_object(params)
            p = Spree::Product
            if !params[:taxon].nil?
                p = Spree::Taxon.where(id: params[:taxon])
                if p.any?
                    p = p.first.products
                end
            end
            return p
        end

        def build_search_params(params)
            params[:q] ||= {}

            if !params[:keywords].nil?
                params[:q][:name_cont] = params[:keywords]
            end

            if !params[:brand].nil?
                params[:q][:producer_id_eq] = params[:brand]
            end

            if !params[:tag].nil?
                params[:q][:meta_keywords_cont] = params[:tag]
            end

            if !params[:taxon].nil?
                params[:q][:taxon_id_eq] = params[:taxon]
            end

            if !params[:sort].nil?
                sort = params[:sort]

                case sort
                when "price"
                    params[:q][:s] = "price asc"
                when "price-desc"
                    params[:q][:s] = "price desc"
                else
                    params[:q][:s] = "created_at desc"
                end
            end

            return params[:q]
        end

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
                return products.sort{|a,b| a.price <=> b.price}
            elsif sort == "price-desc"
                return products.sort{|a,b| b.price <=> a.price}
            elsif sort == "latest"
                return products.sort{|a,b| b.created_at <=> a.created_at}
            end

            return products
        end
    end
end  