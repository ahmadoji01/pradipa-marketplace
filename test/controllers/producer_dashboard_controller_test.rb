require "test_helper"

class ProducerDashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get producer_dashboard_index_url
    assert_response :success
  end

  test "should get orders" do
    get producer_dashboard_orders_url
    assert_response :success
  end

  test "should get withdrawals" do
    get producer_dashboard_withdrawals_url
    assert_response :success
  end

  test "should get request_withdrawal" do
    get producer_dashboard_request_withdrawal_url
    assert_response :success
  end
end
