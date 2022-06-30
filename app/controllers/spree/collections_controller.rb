module Spree
    class CollectionsController < Spree::StoreController
        respond_to :html
        before_action :set_collection, only: %i[ show ]

        def show

        end

        private
            def set_collection
                @collection = Spree::Collection.find_by(slug: params[:slug])
            end

    end
end
