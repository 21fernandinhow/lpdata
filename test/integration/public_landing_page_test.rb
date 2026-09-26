require "test_helper"

class PublicLandingPageTest < ActionDispatch::IntegrationTest
  setup do
    Rails.cache.clear
    @user = User.create!(email: "owner@example.com", password: "password123")
  end

  test "consumer reads a landing page content by its public id" do
    landing_page = @user.landing_pages.create!(
      name: "Launch page",
      current_data: {
        "hero" => {
          "title" => { "value" => "Launch day", "type" => "string" }
        }
      }
    )

    get "/landing_pages/#{landing_page.public_id}"

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

  test "consumer receives a clear error for an unknown public id" do
    get "/landing_pages/999999999"

    assert_response :not_found
    assert_equal({ "error" => "Landing page not found" }, JSON.parse(response.body))
  end

  test "consumer receives arbitrary nested JSON without transformation" do
    content = {
      "sections" => [
        {
          "items" => [
            { "value" => 1, "type" => "number" },
            { "value" => false, "type" => "boolean" },
            { "value" => "", "type" => "string" }
          ]
        },
        { "media" => { "value" => "https://cdn.example/image.webp", "type" => "hosted_file" } }
      ]
    }
    landing_page = @user.landing_pages.create!(name: "Nested page", current_data: content)

    get "/landing_pages/#{landing_page.public_id}"

    assert_response :success
    assert_equal content, JSON.parse(response.body)
  end

  test "consumer is rate limited after thirty requests without a configured origin" do
    landing_page = @user.landing_pages.create!(name: "Limited page", current_data: {})

    30.times do
      get "/landing_pages/#{landing_page.public_id}"
      assert_response :success
    end

    get "/landing_pages/#{landing_page.public_id}"

    assert_response :too_many_requests
    assert_equal "60", response.headers.fetch("Retry-After")
  end

  test "consumer with a configured origin receives the generous rate limit" do
    landing_page = @user.landing_pages.create!(
      name: "Hosted page",
      allowed_hosts: [ "example.com" ],
      current_data: {}
    )

    31.times do
      get "/landing_pages/#{landing_page.public_id}", headers: { "Origin" => "https://www.example.com" }
      assert_response :success
      assert_equal "*", response.headers.fetch("Access-Control-Allow-Origin")
    end
  end
end
