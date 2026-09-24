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

  test "accepts nested editable fields using the value and type convention" do
    landing_page = LandingPage.new(
      public_identifier: "editable-content",
      current_data: {
        "section" => {
          "title" => { "value" => "Launch day", "type" => "string" },
          "count" => { "value" => 3, "type" => "number" }
        }
      }
    )

    assert landing_page.valid?
  end

  test "rejects primitive values outside editable fields" do
    landing_page = LandingPage.new(
      public_identifier: "loose-value",
      current_data: { "title" => "Launch day" }
    )

    assert_not landing_page.valid?
    assert landing_page.errors[:current_data].any? { |error| error.start_with?("contains a value outside an editable field") }
  end

  test "rejects editable fields with only one convention key" do
    landing_page = LandingPage.new(
      public_identifier: "incomplete-field",
      current_data: { "title" => { "value" => "Launch day" } }
    )

    assert_not landing_page.valid?
    assert landing_page.errors[:current_data].any? { |error| error.start_with?("editable fields must contain both value and type") }
  end
end
