require "test_helper"

class LandingPageTest < ActiveSupport::TestCase
  test "accepts an empty JSON object as a content document" do
    landing_page = LandingPage.new(public_identifier: "empty-object", current_data: {})

    assert landing_page.valid?
  end

  test "requires a content document" do
    landing_page = LandingPage.new(public_identifier: "missing-content", current_data: nil)

    assert_not landing_page.valid?
    assert_includes landing_page.errors[:current_data], "can't be blank"
  end
end
