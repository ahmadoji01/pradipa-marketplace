module Spree
    module Admin
        class BlogCategoriesController < Spree::Admin::BaseController
            before_action :set_blog_category, only: %i[ edit update destroy ]

            def index
                params[:q] ||= {}

                @search = BlogCategory.accessible_by(current_ability, :index).ransack(params[:q])
                @search.sorts = 'created_at desc' if @search.sorts.empty?
                @blog_categories = @search.result.
                    page(params[:page]).
                    per(params[:per_page] || Spree::Config[:orders_per_page])
            end
        
            def new
                @blog_category = BlogCategory.new
            end
        
            def edit
                @blog_category = BlogCategory.find(params[:id])
            end
        
            def create
                @blog_category = BlogCategory.new(blog_params)
        
                respond_to do |format|
                if @blog_category.save
                    format.html { redirect_to main_app.admin_blog_categories_path, notice: "Blog category was successfully created." }
                    format.json { render :index, status: :created, location: main_app.admin_blog_categories_path }
                else
                    format.html { render :new, status: :unprocessable_entity }
                    format.json { render json: @blog_category.errors, status: :unprocessable_entity }
                end
                end
            end
        
            def update
                respond_to do |format|
                    if @blog_category.update(blog_params)
                        format.html { redirect_to main_app.admin_blog_categories_path, notice: "Blog category was successfully updated." }
                        format.json { render :index, status: :ok, location: main_app.admin_blog_categories_path }
                    else
                        format.html { render :edit, status: :unprocessable_entity }
                        format.json { render json: @blog_category.errors, status: :unprocessable_entity }
                    end
                end
            end
        
            def destroy
                @blog_category.destroy
                respond_to do |format|
                    format.html { redirect_to main_app.admin_blog_categories_path, notice: "Blog category was successfully destroyed." }
                    format.json { head :no_content }
                end
            end
        
            private
                def set_blog_category
                    @blog_category = BlogCategory.find(params[:id])
                end
        
                # Only allow a list of trusted parameters through.
                def blog_params
                    params.fetch(:blog_category, {}).permit(:id, :name)
                end
        end
    end
end
  