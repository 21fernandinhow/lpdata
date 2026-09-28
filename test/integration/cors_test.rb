require "test_helper"

class CorsTest < ActionDispatch::IntegrationTest
  ALLOWED_ORIGIN = "https://app.example.com"

  test "configured origin can preflight authenticated routes" do
    {
      "/auth/sign_in" => "POST",
      "/manage/landing_pages/1" => "PATCH",
      "/assets/1" => "DELETE"
    }.each do |path, method|
      preflight path, method: method, origin: ALLOWED_ORIGIN

      assert_equal ALLOWED_ORIGIN, response.headers["Access-Control-Allow-Origin"], path
      assert_includes response.headers["Access-Control-Allow-Methods"].to_s, method, path
    end
  end

  test "unknown origin cannot preflight authenticated routes" do
    preflight "/manage/landing_pages", method: "GET", origin: "https://evil.example.com"

    assert_nil response.headers["Access-Control-Allow-Origin"]
  end

  private

  def preflight(path, method:, origin:)
    process :options, path, headers: {
      "Origin" => origin,
      "Access-Control-Request-Method" => method,
      "Access-Control-Request-Headers" => "Authorization, Content-Type"
    }
  end
end
