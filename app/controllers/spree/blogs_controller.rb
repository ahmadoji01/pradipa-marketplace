module Spree
  class BlogsController < Spree::StoreController
    before_action :set_spree_blog, only: %i[ show ]
    before_action :set_blog_categories

    # GET /spree/blogs or /spree/blogs.json
    def index
      @blogs = Spree::Blog.where(published: true)
    end

    # GET /spree/blogs/1 or /spree/blogs/1.json
    def show
      @related_posts = Spree::Blog.where(blog_category: @spree_blog.blog_category).order('created_at desc').limit(2)
    end

    def show_post
      @spree_blog = Spree::Blog.find_by(slug: params["slug"])
      @related_posts = Spree::Blog.where(blog_category: @spree_blog.blog_category).order('created_at desc').limit(2)
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
