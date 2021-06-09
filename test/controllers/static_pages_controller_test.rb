require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get about" do
    get static_pages_about_url
    assert_response :success
  end

  test "should get terms-and-conditions" do
    get static_pages_terms-and-conditions_url
    assert_response :success
  end

  test "should get privacy-policy" do
    get static_pages_privacy-policy_url
    assert_response :success
  end

  test "should get return-policy" do
    get static_pages_return-policy_url
    assert_response :success
  end

  test "should get faq" do
    get static_pages_faq_url
    assert_response :success
  end

  test "should get order-status" do
    get static_pages_order-status_url
    assert_response :success
  end

  test "should get track-my-package" do
    get static_pages_track-my-package_url
    assert_response :success
  end

  test "should get contact-us" do
    get static_pages_contact-us_url
    assert_response :success
  end
end
