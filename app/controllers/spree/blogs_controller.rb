module Spree
  class BlogsController < Spree::StoreController
    before_action :set_spree_blog, only: %i[ show edit update destroy ]
    before_action :set_blog_categories

    # GET /spree/blogs or /spree/blogs.json
    def index
      @spree_blogs = Spree::Blog.all
      @blogs = Spree::Blog.last(6)
    end

    # GET /spree/blogs/1 or /spree/blogs/1.json
    def show
      @related_posts = Spree::Blog.where(blog_category: @spree_blog.blog_category).order('created_at desc').limit(2)
    end

    # GET /spree/blogs/new
    def new
      @spree_blog = Spree::Blog.new
      @blog_categories = BlogCategory.all
    end

    # GET /spree/blogs/1/edit
    def edit
    end

    # POST /spree/blogs or /spree/blogs.json
    def create
      @spree_blog = Spree::Blog.new(spree_blog_params)
      @spree_blog.blog_category_id = params[:blog_category]

      respond_to do |format|
        if @spree_blog.save
          format.html { redirect_to main_app.blog_path(@spree_blog), notice: "Blog was successfully created." }
          format.json { render :show, status: :created, location: main_app.blogs_path(@spree_blog) }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @spree_blog.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /spree/blogs/1 or /spree/blogs/1.json
    def update
      @spree_blog.blog_category_id = params[:blog_category]
      respond_to do |format|
        if @spree_blog.update(spree_blog_params)
          format.html { redirect_to main_app.blog_path(@spree_blog), notice: "Blog was successfully updated." }
          format.json { render :show, status: :ok, location: main_app.blog_path(@spree_blog) }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @spree_blog.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /spree/blogs/1 or /spree/blogs/1.json
    def destroy
      @spree_blog.destroy
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
      def set_spree_blog
        @spree_blog = Spree::Blog.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def spree_blog_params
        params.fetch(:spree_blog, {}).permit(:title, :body, :meta_title, :meta_keyword, :subtitle, :featured_image, :edited_at, :blog_category, :blog_category_id)
      end
  end
end
