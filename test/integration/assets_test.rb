require "test_helper"

class AssetsTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "owner@example.com", password: "password123")

    post "/auth/sign_in", params: {
      user: { email: @user.email, password: "password123" }
    }, as: :json

    @access_token = JSON.parse(response.body).fetch("access_token")
  end

  test "authenticated user uploads an asset and receives metadata and a public URL" do
    file = fixture_file_upload("example.txt", "text/plain")

    post "/api/v1/assets", params: {
      asset: { file: file }
    }, headers: { "Authorization" => "Bearer #{@access_token}" }

    assert_response :created

    response_body = JSON.parse(response.body)
    assert_equal @user.id, response_body.dig("asset", "user_id")
    assert_equal "example.txt", response_body.dig("asset", "filename")
    assert_equal "text/plain", response_body.dig("asset", "content_type")
    assert response_body.dig("asset", "public_url").present?
  end

  test "authenticated user lists only their assets" do
    asset = @user.assets.create!(file: fixture_file_upload("example.txt", "text/plain"))
    other_user = User.create!(email: "other@example.com", password: "password123")
    other_user.assets.create!(file: fixture_file_upload("example.txt", "text/plain"))

    get "/api/v1/assets",
      headers: { "Authorization" => "Bearer #{@access_token}" },
      as: :json

    assert_response :success
    bodies = JSON.parse(response.body).fetch("assets")
    assert_equal [ asset.id ], bodies.map { |item| item.fetch("id") }
  end

  test "authenticated user reads one of their assets" do
    asset = @user.assets.create!(file: fixture_file_upload("example.txt", "text/plain"))

    get "/api/v1/assets/#{asset.id}",
      headers: { "Authorization" => "Bearer #{@access_token}" },
      as: :json

    assert_response :success
    response_body = JSON.parse(response.body).fetch("asset")
    assert_equal asset.id, response_body.fetch("id")
    assert_equal asset.file.filename.to_s, response_body.fetch("filename")
  end

  test "authenticated user deletes their asset" do
    asset = @user.assets.create!(file: fixture_file_upload("example.txt", "text/plain"))

    delete "/api/v1/assets/#{asset.id}",
      headers: { "Authorization" => "Bearer #{@access_token}" },
      as: :json

    assert_response :no_content
    assert_not Asset.exists?(asset.id)
  end

  test "user cannot access another user's asset" do
    other_user = User.create!(email: "other@example.com", password: "password123")
    asset = other_user.assets.create!(file: fixture_file_upload("example.txt", "text/plain"))

    get "/api/v1/assets/#{asset.id}",
      headers: { "Authorization" => "Bearer #{@access_token}" },
      as: :json

    assert_response :not_found
  end

  test "unauthenticated user cannot manage assets" do
    get "/api/v1/assets", as: :json
    assert_response :unauthorized
  end
end
