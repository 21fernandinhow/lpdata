require "test_helper"

class PublicLandingPageTest < ActionDispatch::IntegrationTest
  test "consumer reads a landing page content by its public identifier" do
    landing_page = LandingPage.create!(
      public_identifier: "launch-page",
      current_data: {
        "hero" => {
          "title" => { "value" => "Launch day", "type" => "string" }
        }
      }
    )

    get "/api/v1/landing_pages/#{landing_page.public_identifier}"

    assert_response :success
    assert_equal(
      {
        "hero" => {
          "title" => { "value" => "Launch day", "type" => "string" }
        }
      },
      JSON.parse(response.body)
    )
  end

  test "consumer receives a clear error for an unknown public identifier" do
    get "/api/v1/landing_pages/unknown-page"

    assert_response :not_found
    assert_equal({ "error" => "Landing page not found" }, JSON.parse(response.body))
  end
end
