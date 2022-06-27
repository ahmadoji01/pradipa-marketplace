module Spree
    class CollectionDisplayController < Spree::StoreController
        respond_to :html

        def show
            @query = params[:slug]
            @ok = false
            @full_path = ""

            if File.directory?("./app/assets/images/collection_entries/" + @query)
                @ok = true
            end
            if !@ok
                raise ActionController::RoutingError.new('Not Found')
            end

            full_path = "./app/assets/images/collection_entries/" + @query
            @coll_info = ""
            if File.exist?(full_path + "/info.txt")
                @coll_info = File.read(full_path + "/info.txt")
            else
                @coll_info = File.read("./app/assets/images/collection_entries/default/info.txt")
            end
        end

    end
end
