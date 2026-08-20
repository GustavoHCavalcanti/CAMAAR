require "test_helper"

class Respondente::FormulariosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get respondente_formularios_index_url
    assert_response :success
  end

  test "should get show" do
    get respondente_formularios_show_url
    assert_response :success
  end
end
