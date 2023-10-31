require "application_system_test_case"

class ScrapsTest < ApplicationSystemTestCase
  setup do
    @scrap = scraps(:one)
  end

  test "visiting the index" do
    visit scraps_url
    assert_selector "h1", text: "Scraps"
  end

  test "should create scrap" do
    visit scraps_url
    click_on "New scrap"

    fill_in "Keywords", with: @scrap.keywords
    fill_in "Urls", with: @scrap.urls
    click_on "Create Scrap"

    assert_text "Scrap was successfully created"
    click_on "Back"
  end

  test "should update Scrap" do
    visit scrap_url(@scrap)
    click_on "Edit this scrap", match: :first

    fill_in "Keywords", with: @scrap.keywords
    fill_in "Urls", with: @scrap.urls
    click_on "Update Scrap"

    assert_text "Scrap was successfully updated"
    click_on "Back"
  end

  test "should destroy Scrap" do
    visit scrap_url(@scrap)
    click_on "Destroy this scrap", match: :first

    assert_text "Scrap was successfully destroyed"
  end
end
