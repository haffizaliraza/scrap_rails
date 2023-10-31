require "test_helper"

class ScrapsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @scrap = scraps(:one)
  end

  test "should get index" do
    get scraps_url
    assert_response :success
  end

  test "should get new" do
    get new_scrap_url
    assert_response :success
  end

  test "should create scrap" do
    assert_difference("Scrap.count") do
      post scraps_url, params: { scrap: { keywords: @scrap.keywords, urls: @scrap.urls } }
    end

    assert_redirected_to scrap_url(Scrap.last)
  end

  test "should show scrap" do
    get scrap_url(@scrap)
    assert_response :success
  end

  test "should get edit" do
    get edit_scrap_url(@scrap)
    assert_response :success
  end

  test "should update scrap" do
    patch scrap_url(@scrap), params: { scrap: { keywords: @scrap.keywords, urls: @scrap.urls } }
    assert_redirected_to scrap_url(@scrap)
  end

  test "should destroy scrap" do
    assert_difference("Scrap.count", -1) do
      delete scrap_url(@scrap)
    end

    assert_redirected_to scraps_url
  end
end
