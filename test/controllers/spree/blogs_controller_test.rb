require "test_helper"

class Spree::BlogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @spree_blog = spree_blogs(:one)
  end

  test "should get index" do
    get spree_blogs_url
    assert_response :success
  end

  test "should get new" do
    get new_spree_blog_url
    assert_response :success
  end

  test "should create spree_blog" do
    assert_difference('Spree::Blog.count') do
      post spree_blogs_url, params: { spree_blog: { body: @spree_blog.body, category: @spree_blog.category, edited_at: @spree_blog.edited_at, featured_image: @spree_blog.featured_image, meta_keyword: @spree_blog.meta_keyword, meta_title: @spree_blog.meta_title, subtitle: @spree_blog.subtitle, title: @spree_blog.title } }
    end

    assert_redirected_to spree_blog_url(Spree::Blog.last)
  end

  test "should show spree_blog" do
    get spree_blog_url(@spree_blog)
    assert_response :success
  end

  test "should get edit" do
    get edit_spree_blog_url(@spree_blog)
    assert_response :success
  end

  test "should update spree_blog" do
    patch spree_blog_url(@spree_blog), params: { spree_blog: { body: @spree_blog.body, category: @spree_blog.category, edited_at: @spree_blog.edited_at, featured_image: @spree_blog.featured_image, meta_keyword: @spree_blog.meta_keyword, meta_title: @spree_blog.meta_title, subtitle: @spree_blog.subtitle, title: @spree_blog.title } }
    assert_redirected_to spree_blog_url(@spree_blog)
  end

  test "should destroy spree_blog" do
    assert_difference('Spree::Blog.count', -1) do
      delete spree_blog_url(@spree_blog)
    end

    assert_redirected_to spree_blogs_url
  end
end
