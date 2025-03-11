require "test_helper"

class CompanyAiProvidersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get company_ai_providers_index_url
    assert_response :success
  end

  test "should get show" do
    get company_ai_providers_show_url
    assert_response :success
  end

  test "should get new" do
    get company_ai_providers_new_url
    assert_response :success
  end

  test "should get create" do
    get company_ai_providers_create_url
    assert_response :success
  end

  test "should get edit" do
    get company_ai_providers_edit_url
    assert_response :success
  end

  test "should get update" do
    get company_ai_providers_update_url
    assert_response :success
  end

  test "should get destroy" do
    get company_ai_providers_destroy_url
    assert_response :success
  end
end
