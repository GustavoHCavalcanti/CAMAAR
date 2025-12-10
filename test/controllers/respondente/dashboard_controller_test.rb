require "test_helper"

class Respondente::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get respondente_dashboard_index_url
    assert_response :success
  end
end
