module Spree
    module Admin
        class BlogsController < Spree::Admin::BaseController
            before_action :set_blog, only: %i[ show edit update destroy ]
            before_action :set_blog_categories

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

                @search = Spree::Blog.accessible_by(current_ability, :index).ransack(params[:q])
                @search.sorts = 'created_at desc' if @search.sorts.empty?
                @blogs = @search.result.
                    page(params[:page]).
                    per(params[:per_page] || Spree::Config[:orders_per_page])
            end
        
            # GET /spree/blogs/new
            def new
                @blog = Spree::Blog.new
                @blog_categories = BlogCategory.all
            end
        
            # GET /spree/blogs/1/edit
            def edit
                @blog = Spree::Blog.find(params[:id])
            end
        
            # POST /spree/blogs or /spree/blogs.json
            def create
                @blog = Spree::Blog.new(blog_params)
                 
                respond_to do |format|
                if @blog.save
                    format.html { redirect_to main_app.blog_path(@blog), notice: "Blog was successfully created." }
                    format.json { render :show, status: :created, location: main_app.blogs_path(@spree_blog) }
                else
                    format.html { render :new, status: :unprocessable_entity }
                    format.json { render json: @spree_blog.errors, status: :unprocessable_entity }
                end
                end
            end
        
            # PATCH/PUT /spree/blogs/1 or /spree/blogs/1.json
            def update
                respond_to do |format|
                    if @blog.update(blog_params)
                        format.html { redirect_to main_app.edit_admin_blog_path(@blog), notice: "Blog was successfully updated." }
                        format.json { render :show, status: :ok, location: main_app.blog_path(@spree_blog) }
                    else
                        format.html { render :edit, status: :unprocessable_entity }
                        format.json { render json: @spree_blog.errors, status: :unprocessable_entity }
                    end
                end
            end
        
            # DELETE /spree/blogs/1 or /spree/blogs/1.json
            def destroy
                @blog.destroy
                respond_to do |format|
                    format.html { redirect_to main_app.blogs_path, notice: "Blog was successfully destroyed." }
                    format.json { head :no_content }
                end
            end
        
            private
                def set_blog_categories
                    @blog_categories = BlogCategory.all
                end
        
                # Use callbacks to share common setup or constraints between actions.
                def set_blog
                    @blog = Spree::Blog.find(params[:id])
                end
        
                # Only allow a list of trusted parameters through.
                def blog_params
                    params.fetch(:blog, {}).permit(:title, :body, :published, :meta_title, :meta_keyword, :subtitle, :featured_image, :edited_at, :blog_category_id)
                end
        end
    end
end
  