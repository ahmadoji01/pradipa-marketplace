module Spree
  class BlogsController < Spree::StoreController
    before_action :set_spree_blog, only: %i[ show edit update destroy ]

    # GET /spree/blogs or /spree/blogs.json
    def index
      @spree_blogs = Spree::Blog.all
    end

    # GET /spree/blogs/1 or /spree/blogs/1.json
    def show
    end

    # GET /spree/blogs/new
    def new
      @spree_blog = Spree::Blog.new
    end

    # GET /spree/blogs/1/edit
    def edit
    end

    # POST /spree/blogs or /spree/blogs.json
    def create
      @spree_blog = Spree::Blog.new(spree_blog_params)

      respond_to do |format|
        if @spree_blog.save
          format.html { redirect_to @spree_blog, notice: "Blog was successfully created." }
          format.json { render :show, status: :created, location: @spree_blog }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @spree_blog.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /spree/blogs/1 or /spree/blogs/1.json
    def update
      respond_to do |format|
        if @spree_blog.update(spree_blog_params)
          format.html { redirect_to @spree_blog, notice: "Blog was successfully updated." }
          format.json { render :show, status: :ok, location: @spree_blog }
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
        format.html { redirect_to spree_blogs_url, notice: "Blog was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_spree_blog
        @spree_blog = Spree::Blog.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def spree_blog_params
        params.require(:spree_blog).permit(:title, :body, :meta_title, :meta_keyword, :subtitle, :featured_image, :edited_at, :category)
      end
  end
end
