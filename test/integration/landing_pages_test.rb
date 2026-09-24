require "test_helper"

class LandingPagesTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "owner@example.com", password: "password123")

    post "/api/v1/auth/sign_in", params: {
      user: { email: @user.email, password: "password123" }
    }, as: :json

    @access_token = JSON.parse(response.body).fetch("access_token")
  end

  test "authenticated user creates a landing page" do
    content = {
      "hero" => {
        "title" => { "value" => "Launch day", "type" => "string" }
      }
    }

    post "/api/v1/landing_pages", params: {
      landing_page: {
        name: "Launch page",
        current_data: content
      }
    }, headers: { "Authorization" => "Bearer #{@access_token}" }, as: :json

    assert_response :created

    response_body = JSON.parse(response.body)
    assert response_body.dig("landing_page", "id").present?
    assert_equal "Launch page", response_body.dig("landing_page", "name")
    assert response_body.dig("landing_page", "public_id").present?
    assert_equal content, response_body.dig("landing_page", "current_data")
    assert_equal @user.id, response_body.dig("landing_page", "user_id")
  end

  test "authenticated user lists only their landing pages" do
    @user.landing_pages.create!(name: "Owned page", current_data: {})
    other_user = User.create!(email: "other@example.com", password: "password123")
    other_user.landing_pages.create!(name: "Other page", current_data: {})

    get "/api/v1/manage/landing_pages",
      headers: { "Authorization" => "Bearer #{@access_token}" },
      as: :json

    assert_response :success
    landing_page = JSON.parse(response.body).fetch("landing_pages").first
    assert_equal "Owned page", landing_page.fetch("name")
    assert_equal @user.landing_pages.first.public_id, landing_page.fetch("public_id")
  end

  test "authenticated user reads one of their landing pages" do
    landing_page = @user.landing_pages.create!(name: "Owned page", current_data: {})

    get "/api/v1/manage/landing_pages/#{landing_page.id}",
      headers: { "Authorization" => "Bearer #{@access_token}" },
      as: :json

    assert_response :success
    response_body = JSON.parse(response.body).fetch("landing_page")
    assert_equal landing_page.id, response_body.fetch("id")
    assert_equal landing_page.public_id, response_body.fetch("public_id")
  end

  test "authenticated user replaces the complete content document" do
    landing_page = @user.landing_pages.create!(
      name: "Owned page",
      current_data: { "title" => { "value" => "Before", "type" => "string" } }
    )
    replacement = { "items" => [ { "value" => 3, "type" => "number" } ] }

    patch "/api/v1/manage/landing_pages/#{landing_page.id}", params: {
      landing_page: { name: "Renamed page", current_data: replacement }
    }, headers: { "Authorization" => "Bearer #{@access_token}" }, as: :json

    assert_response :success
    response_body = JSON.parse(response.body).fetch("landing_page")
    assert_equal "Renamed page", response_body.fetch("name")
    assert_equal replacement, response_body.fetch("current_data")
  end

  test "authenticated user deletes their landing page" do
    landing_page = @user.landing_pages.create!(name: "Owned page", current_data: {})

    delete "/api/v1/manage/landing_pages/#{landing_page.id}",
      headers: { "Authorization" => "Bearer #{@access_token}" },
      as: :json

    assert_response :no_content
    assert_not LandingPage.exists?(landing_page.id)
  end

  test "user cannot access another user's landing page" do
    other_user = User.create!(email: "other@example.com", password: "password123")
    landing_page = other_user.landing_pages.create!(name: "Other page", current_data: {})

    get "/api/v1/manage/landing_pages/#{landing_page.id}",
      headers: { "Authorization" => "Bearer #{@access_token}" },
      as: :json

    assert_response :not_found
  end

  test "unauthenticated user cannot list landing pages" do
    get "/api/v1/manage/landing_pages", as: :json

    assert_response :unauthorized
    assert_equal(
      { "error" => "You need to sign in or sign up before continuing." },
      JSON.parse(response.body)
    )
  end

  test "invalid content returns a JSON validation error" do
    post "/api/v1/landing_pages", params: {
      landing_page: {
        name: "Invalid page",
        current_data: { "title" => "Loose value" }
      }
    }, headers: { "Authorization" => "Bearer #{@access_token}" }, as: :json

    assert_response :unprocessable_content
    assert JSON.parse(response.body).fetch("errors").any? { |error| error.include?("outside an editable field") }
  end
end
