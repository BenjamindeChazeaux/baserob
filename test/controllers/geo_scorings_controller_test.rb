require "test_helper"

class GeoScoringsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get geo_scorings_index_url
    assert_response :success
  end

  test "should get show" do
    get geo_scorings_show_url
    assert_response :success
  end

  test "should get update" do
    get geo_scorings_update_url
    assert_response :success
  end
end
