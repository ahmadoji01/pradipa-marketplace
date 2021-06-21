require "test_helper"

class Spree::StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get about" do
    get spree_static_pages_about_url
    assert_response :success
  end
end
