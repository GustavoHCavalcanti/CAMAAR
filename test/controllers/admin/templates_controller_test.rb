require "test_helper"

class Admin::TemplatesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_templates_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_templates_show_url
    assert_response :success
  end

  test "should get new" do
    get admin_templates_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_templates_create_url
    assert_response :success
  end

  test "should get edit" do
    get admin_templates_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_templates_update_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_templates_destroy_url
    assert_response :success
  end
end
