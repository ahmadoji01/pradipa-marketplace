module Spree
  class BlogsController < Spree::StoreController
    before_action :set_blog, only: %i[ show ]
    before_action :set_blog_categories

    # GET /spree/blogs or /spree/blogs.json
    def index

      params[:q] ||= {}

      if !params[:category_id].nil?
        params[:q][:blog_category_id_eq] = params[:category_id]
      end

      if !params[:tag].nil?
        params[:q][:meta_keyword_cont] = params[:tag]
      end

      params[:q][:published_true] = '1'
      @q = Spree::Blog.ransack(params[:q])
      @blogs = @q.result(distinct: true).
        page(params[:page]).
        per(params[:per_page] || Spree::Config[:orders_per_page])
      @recent_blogs = Spree::Blog.all.last(3)

      @categories = BlogCategory.all
    end

    # GET /spree/blogs/1 or /spree/blogs/1.json
    def show
      @related_posts = Spree::Blog.where(blog_category: @blog.blog_category).order('created_at desc').limit(2)
    end

    def show_post
      @blog = Spree::Blog.find_by(slug: params["slug"])
      @related_posts = Spree::Blog.where(blog_category: @blog.blog_category).order('created_at desc').limit(2)
      @tags = @blog.meta_keyword.split(", ")
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
      def spree_blog_params
        params.fetch(:spree_blog, {}).permit(:title, :body, :meta_title, :meta_keyword, :subtitle, :featured_image, :edited_at, :blog_category, :blog_category_id)
      end
  end
end
