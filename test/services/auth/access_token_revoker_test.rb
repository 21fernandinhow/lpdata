require "test_helper"

module Auth
  class AccessTokenRevokerTest < ActiveSupport::TestCase
    setup do
      @user = User.create!(email: "owner@example.com", password: "password123")
    end

    test "revokes a valid access token" do
      access_token = TokenIssuer.access_token_for(@user)

      assert AccessTokenRevoker.call(access_token)
      assert_equal 1, JwtDenylist.count
    end

    test "treats an expired access token as already revoked" do
      access_token = TokenIssuer.access_token_for(@user)

      travel 2.hours + 1.minute do
        assert AccessTokenRevoker.call(access_token)
      end
      assert_equal 0, JwtDenylist.count
    end

    test "rejects a malformed access token" do
      assert_not AccessTokenRevoker.call("not-a-jwt")
    end
  end
end
