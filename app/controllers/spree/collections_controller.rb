module Spree
    class CollectionsController < Spree::StoreController
        respond_to :html
        before_action :set_collection, only: %i[ show ]

        def show
            if @collection.nil?
                raise ActionController::RoutingError.new('Not Found')
            end
        end

        def discover
            @collection = Spree::Collection.find_by(slug: params[:slug])

            if @collection.nil?
                raise ActionController::RoutingError.new('Not Found')
            end

            @products = @collection.products
            @paginated_products = Kaminari.paginate_array(@products).page(params[:page]).per(16)
            @total = @paginated_products.total_count
        end

        private
            def set_collection
                @collection = Spree::Collection.find_by(slug: params[:slug])
            end

    end
end
