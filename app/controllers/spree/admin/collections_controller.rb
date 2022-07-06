module Spree
    module Admin
        class CollectionsController < Spree::Admin::BaseController
            before_action :set_collection, only: %i[ show edit update destroy ]

            def index
                params[:q] ||= {}
                params[:q][:published] ||= '1' if !params[:q][:published].nil?
                @show_only_published = params[:q][:published] == '1'
                params[:q][:s] ||= 'created_at desc'

                created_at_gt = params[:q][:created_at_gt]
                created_at_lt = params[:q][:created_at_lt]

                if params[:q][:created_at_gt].present?
                params[:q][:created_at_gt] = begin
                                                Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day
                                            rescue StandardError
                                                ""
                                            end
                end

                if params[:q][:created_at_lt].present?
                params[:q][:created_at_lt] = begin
                                                Time.zone.parse(params[:q][:created_at_lt]).end_of_day
                                            rescue StandardError
                                                ""
                                            end
                end

                if @show_only_published
                    params[:q][:published_true] = 1
                end

                @search = Spree::Collection.accessible_by(current_ability, :index).ransack(params[:q])
                @search.sorts = 'created_at desc' if @search.sorts.empty?
                @collections = @search.result.
                    page(params[:page]).
                    per(params[:per_page] || Spree::Config[:orders_per_page])
            end
        
            # GET /spree/blogs/new
            def new
                @collection = Spree::Collection.new
            end
        
            # GET /spree/blogs/1/edit
            def edit
                @collection = Spree::Collection.find(params[:id])
            end
        
            # POST /spree/blogs or /spree/blogs.json
            def create
                @collection = Spree::Collection.new(collection_params)
                @collection.product_ids = params[:collection][:product_ids]
                @collection.blog_ids = params[:collection][:blog_ids]
                
                respond_to do |format|
                    if @collection.save
                        format.html { redirect_to main_app.collection_page_path(@collection.slug), notice: "Collection was successfully created." }
                        format.json { render :show, status: :created, location: main_app.collections_path(@collection) }
                    else
                        format.html { render :new, status: :unprocessable_entity }
                        format.json { render json: @collection.errors, status: :unprocessable_entity }
                    end
                end
            end
        
            # PATCH/PUT /spree/blogs/1 or /spree/blogs/1.json
            def update
                @collection.product_ids = params[:collection][:product_ids]
                @collection.blog_ids = params[:collection][:blog_ids]
                
                respond_to do |format|
                    if @collection.update(collection_params)
                        format.html { redirect_to main_app.edit_admin_collection_path(@collection), notice: "Collection was successfully updated." }
                        format.json { render :show, status: :ok, location: main_app.collection_path(@collection) }
                    else
                        format.html { render :edit, status: :unprocessable_entity }
                        format.json { render json: @collection.errors, status: :unprocessable_entity }
                    end
                end
            end
        
            # DELETE /spree/blogs/1 or /spree/blogs/1.json
            def destroy
                @collection.destroy
                respond_to do |format|
                    format.html { redirect_to main_app.admin_collections_path, notice: "Collection was successfully destroyed." }
                    format.json { head :no_content }
                end
            end
        
            private
        
                # Use callbacks to share common setup or constraints between actions.
                def set_collection
                    @collection = Spree::Collection.find(params[:id])
                end
        
                # Only allow a list of trusted parameters through.
                def collection_params
                    params.fetch(:collection, {}).permit(:name, :slug, :collection_description, :published, :meta_description, :meta_keywords, :meta_tags, :featured_image, :featured_video, :summary_image, :summary_description, :edited_at, :product_ids, :blog_ids, :production_image, :production_video, :production_description, :featured_video, :production_video)
                end
        end
    end
end
  