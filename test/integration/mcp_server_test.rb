require "test_helper"

class McpServerTest < ActionDispatch::IntegrationTest
  include McpTestHelper

  PASSWORD = "password123".freeze

  setup do
    # The public read limiter and the session cache share the store.
    Rails.cache.clear
    @user = User.create!(email: "owner@example.com", password: PASSWORD)
    mcp_connect(email: @user.email, password: PASSWORD)
  end

  # --- Connection and discovery -------------------------------------------

  test "the ten tools are discoverable" do
    names = mcp_tools.map { |tool| tool["name"] }

    assert_equal %w[
      check_connection
      create_landing_page
      list_landing_pages
      get_landing_page
      update_landing_page
      delete_landing_page
      get_public_content
      list_assets
      get_asset_upload_command
      delete_asset
    ].sort, names.sort
  end

  test "check_connection returns the authenticated account" do
    body = mcp_tool_json("check_connection")

    assert_equal({ "id" => @user.id, "email" => @user.email }, body.fetch("user"))
  end

  test "check_connection carries the content document contract in its description" do
    description = mcp_tools.find { |tool| tool["name"] == "check_connection" }.fetch("description")

    assert_includes description, "value"
    assert_includes description, "type"
    assert_includes description, "hosted_file"
    assert_includes description, "contains a value outside an editable field"
  end

  # --- Authentication ------------------------------------------------------

  test "a request without credential headers is refused with 401" do
    mcp_request("tools/list", nil, email: nil, password: nil)

    assert_response :unauthorized
    assert_includes response.body, "X-LPData-Email"
    assert_includes response.body, "X-LPData-Password"
  end

  test "a request with a wrong password is refused with 401" do
    mcp_request("tools/list", nil, password: "wrong-password")

    assert_response :unauthorized
    assert_includes response.body, "X-LPData-Email"
  end

  test "the session caches the user so bcrypt runs once" do
    verifications = counting_password_verifications do
      mcp_connect(email: @user.email, password: PASSWORD)
      3.times { mcp_tool_json("check_connection") }
    end

    assert_equal 1, verifications,
      "a session pays bcrypt on the handshake and never again"
  end

  test "the session cache is keyed by the credential, not by the session alone" do
    verifications = counting_password_verifications do
      mcp_request("tools/list", nil, password: "wrong-password")
    end

    assert_response :unauthorized
    assert_equal 1, verifications,
      "a different password on an established session must be verified, not served from the cache"
  end

  # --- Landing pages -------------------------------------------------------

  test "create_landing_page stores the document and returns the record" do
    content = { "hero" => { "title" => { "value" => "Launch day", "type" => "string" } } }

    body = mcp_tool_json("create_landing_page", {
      name: "Launch page",
      current_data: content,
      allowed_hosts: [ "Example.COM" ]
    })

    landing_page = body.fetch("landing_page")
    assert_equal "Launch page", landing_page.fetch("name")
    assert_equal content, landing_page.fetch("current_data")
    assert_equal [ "example.com" ], landing_page.fetch("allowed_hosts")
    assert landing_page.fetch("public_id").present?
    assert_equal @user.id, landing_page.fetch("user_id")
    assert_equal 1, @user.landing_pages.count
  end

  test "create_landing_page without allowed hosts defaults to an empty list" do
    body = mcp_tool_json("create_landing_page", { name: "Plain", current_data: {} })

    assert_equal [], body.dig("landing_page", "allowed_hosts")
  end

  test "create_landing_page passes the validation error through with its path" do
    result = mcp_call_tool("create_landing_page", {
      name: "Broken",
      current_data: { "features" => [ "Fast" ] }
    })

    assert result.fetch("isError")
    assert_includes result.dig("content", 0, "text"),
      "contains a value outside an editable field at $.features[0]"
    assert_equal 0, @user.landing_pages.count
  end

  test "list_landing_pages omits current_data" do
    @user.landing_pages.create!(name: "First", current_data: { "a" => { "value" => "b", "type" => "string" } })

    items = mcp_tool_json("list_landing_pages").fetch("landing_pages")

    assert_equal 1, items.size
    assert_equal "First", items.first.fetch("name")
    assert_not items.first.key?("current_data")
  end

  test "get_landing_page returns the full record with current_data" do
    content = { "a" => { "value" => "b", "type" => "string" } }
    landing_page = @user.landing_pages.create!(name: "First", current_data: content)

    body = mcp_tool_json("get_landing_page", { id: landing_page.id })

    assert_equal content, body.dig("landing_page", "current_data")
  end

  test "update_landing_page replaces only the arguments it was given" do
    landing_page = @user.landing_pages.create!(
      name: "First",
      current_data: { "a" => { "value" => "b", "type" => "string" } },
      allowed_hosts: [ "example.com" ]
    )
    new_content = { "a" => { "value" => "c", "type" => "string" } }

    body = mcp_tool_json("update_landing_page", { id: landing_page.id, current_data: new_content })

    assert_equal new_content, body.dig("landing_page", "current_data")
    assert_equal "First", body.dig("landing_page", "name")
    assert_equal [ "example.com" ], body.dig("landing_page", "allowed_hosts")
  end

  test "update_landing_page renames without touching the document" do
    content = { "a" => { "value" => "b", "type" => "string" } }
    landing_page = @user.landing_pages.create!(name: "First", current_data: content)

    body = mcp_tool_json("update_landing_page", { id: landing_page.id, name: "Renamed" })

    assert_equal "Renamed", body.dig("landing_page", "name")
    assert_equal content, landing_page.reload.current_data
  end

  test "update_landing_page passes the validation error through" do
    landing_page = @user.landing_pages.create!(name: "First", current_data: {})

    result = mcp_call_tool("update_landing_page", {
      id: landing_page.id,
      current_data: { "hero" => { "title" => { "value" => 1, "type" => "string" } } }
    })

    assert result.fetch("isError")
    assert_includes result.dig("content", 0, "text"), "$.hero.title"
    assert_equal({}, landing_page.reload.current_data)
  end

  test "delete_landing_page removes the record" do
    landing_page = @user.landing_pages.create!(name: "First", current_data: {})

    mcp_tool_json("delete_landing_page", { id: landing_page.id })

    assert_equal 0, @user.landing_pages.count
  end

  # --- Scope by user -------------------------------------------------------

  test "a user does not see or touch another user's landing pages" do
    other = User.create!(email: "other@example.com", password: PASSWORD)
    other_page = other.landing_pages.create!(name: "Theirs", current_data: {})

    assert_equal [], mcp_tool_json("list_landing_pages").fetch("landing_pages")

    %w[get_landing_page update_landing_page delete_landing_page].each do |tool|
      result = mcp_call_tool(tool, { id: other_page.id })
      assert result.fetch("isError"), "#{tool} must not reach another user's landing page"
      assert_includes result.dig("content", 0, "text"), "Landing page not found"
    end

    assert other_page.reload.persisted?
  end

  test "a second user connects with their own credentials and sees their own pages" do
    other = User.create!(email: "other@example.com", password: PASSWORD)
    other.landing_pages.create!(name: "Theirs", current_data: {})
    @user.landing_pages.create!(name: "Mine", current_data: {})

    mcp_connect(email: other.email, password: PASSWORD)

    names = mcp_tool_json("list_landing_pages").fetch("landing_pages").map { |page| page["name"] }
    assert_equal [ "Theirs" ], names
    assert_equal other.email, mcp_tool_json("check_connection").dig("user", "email")
  end

  # --- Public read ---------------------------------------------------------

  test "get_public_content returns the raw document with no envelope" do
    content = { "hero" => { "title" => { "value" => "Launch day", "type" => "string" } } }
    landing_page = @user.landing_pages.create!(name: "First", current_data: content)

    body = mcp_tool_json("get_public_content", { public_id: landing_page.public_id })

    assert_equal content, body
  end

  test "get_public_content reports an unknown public id" do
    result = mcp_call_tool("get_public_content", { public_id: 999_999_999 })

    assert result.fetch("isError")
    assert_includes result.dig("content", 0, "text"), "Landing page not found"
  end

  test "get_public_content is throttled like the public endpoint" do
    landing_page = @user.landing_pages.create!(name: "First", current_data: {})
    arguments = { public_id: landing_page.public_id }

    PublicRateLimiter::DEFAULT_LIMIT.times do
      assert_not mcp_call_tool("get_public_content", arguments).fetch("isError")
    end

    result = mcp_call_tool("get_public_content", arguments)
    assert result.fetch("isError")
    assert_includes result.dig("content", 0, "text"), "Too many requests"
    assert_includes result.dig("content", 0, "text"), "Retry-After"
  end

  # --- Assets --------------------------------------------------------------

  test "list_assets returns metadata and the public URL" do
    @user.assets.create!(file: fixture_file_upload("example.txt", "text/plain"))

    asset = mcp_tool_json("list_assets").fetch("assets").sole

    assert_equal "example.txt", asset.fetch("filename")
    assert_equal "text/plain", asset.fetch("content_type")
    assert asset.fetch("byte_size").positive?
    assert asset.fetch("public_url").start_with?("http")
  end

  test "list_assets is scoped to the authenticated user" do
    other = User.create!(email: "other@example.com", password: PASSWORD)
    other.assets.create!(file: fixture_file_upload("example.txt", "text/plain"))

    assert_equal [], mcp_tool_json("list_assets").fetch("assets")
  end

  test "get_asset_upload_command interpolates the path and never emits a secret" do
    command = mcp_tool_text("get_asset_upload_command", { file_path: "/tmp/my hero.png" })

    assert_includes command, "/tmp/my hero.png"
    assert_includes command, "$LPDATA_EMAIL"
    assert_includes command, "$LPDATA_PASSWORD"
    assert_includes command, "LPDATA_URL"
    assert_includes command, "jq -r .access_token"
    assert_includes command, "asset[file]=@"
    assert_not_includes command, PASSWORD
  end

  test "delete_asset removes an owned asset and refuses another user's" do
    asset = @user.assets.create!(file: fixture_file_upload("example.txt", "text/plain"))
    other = User.create!(email: "other@example.com", password: PASSWORD)
    other_asset = other.assets.create!(file: fixture_file_upload("example.txt", "text/plain"))

    mcp_tool_json("delete_asset", { id: asset.id })
    assert_equal 0, @user.assets.count

    result = mcp_call_tool("delete_asset", { id: other_asset.id })
    assert result.fetch("isError")
    assert_includes result.dig("content", 0, "text"), "Asset not found"
    assert other_asset.reload.persisted?
  end

  private

  def counting_password_verifications
    count = 0
    original = User.instance_method(:valid_password?)

    User.define_method(:valid_password?) do |password|
      count += 1
      original.bind(self).call(password)
    end

    begin
      yield
    ensure
      User.define_method(:valid_password?, original)
    end

    count
  end
end
