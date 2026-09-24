require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  test "user creates an account through the JSON API" do
    post "/auth/sign_up", params: {
      user: {
        email: "owner@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    }, as: :json

    assert_response :created

    response_body = JSON.parse(response.body)
    assert_equal "owner@example.com", response_body.dig("user", "email")
    assert response_body["access_token"].present?
    assert response_body["refresh_token"].present?
  end

  test "existing user signs in through the JSON API" do
    User.create!(email: "owner@example.com", password: "password123")

    post "/auth/sign_in", params: {
      user: { email: "owner@example.com", password: "password123" }
    }, as: :json

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "owner@example.com", response_body.dig("user", "email")
    assert response_body["access_token"].present?
    assert response_body["refresh_token"].present?
  end

  test "invalid credentials return a JSON error" do
    post "/auth/sign_in", params: {
      user: { email: "missing@example.com", password: "wrong-password" }
    }, as: :json

    assert_response :unauthorized
    assert_equal [ "Invalid email or password" ], JSON.parse(response.body).fetch("errors")
  end

  test "refresh token rotates without requiring a new login" do
    post "/auth/sign_up", params: {
      user: {
        email: "owner@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    }, as: :json
    initial_refresh_token = JSON.parse(response.body).fetch("refresh_token")

    post "/auth/refresh", params: {
      refresh_token: initial_refresh_token
    }, as: :json

    assert_response :success
    rotated_refresh_token = JSON.parse(response.body).fetch("refresh_token")
    assert_not_equal initial_refresh_token, rotated_refresh_token

    post "/auth/refresh", params: {
      refresh_token: initial_refresh_token
    }, as: :json

    assert_response :unauthorized
  end

  test "access token authenticates a private API endpoint" do
    post "/auth/sign_up", params: {
      user: {
        email: "owner@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    }, as: :json
    access_token = JSON.parse(response.body).fetch("access_token")

    get "/auth/me", headers: {
      "Authorization" => "Bearer #{access_token}",
      "Accept" => "application/json"
    }

    assert_response :success
    assert_equal "owner@example.com", JSON.parse(response.body).dig("user", "email")

    get "/auth/me", headers: { "Accept" => "application/json" }

    assert_response :unauthorized
  end

  test "logout revokes the refresh token" do
    post "/auth/sign_up", params: {
      user: {
        email: "owner@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    }, as: :json
    response_body = JSON.parse(response.body)
    access_token = response_body.fetch("access_token")
    refresh_token = response_body.fetch("refresh_token")

    delete "/auth/sign_out",
      params: { refresh_token: refresh_token },
      headers: { "Authorization" => "Bearer #{access_token}" },
      as: :json

    assert_response :no_content

    post "/auth/refresh", params: { refresh_token: refresh_token }, as: :json

    assert_response :unauthorized

    get "/auth/me", headers: {
      "Authorization" => "Bearer #{access_token}",
      "Accept" => "application/json"
    }

    assert_response :unauthorized
  end
end
