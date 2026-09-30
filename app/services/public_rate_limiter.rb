class PublicRateLimiter
  WINDOW = 1.minute

  # Reads whose Origin matches one of the landing page allowed hosts get the
  # browser budget; every other caller, the MCP server included, gets the default.
  DEFAULT_LIMIT = 30
  ALLOWED_ORIGIN_LIMIT = 1_000

  def initialize(cache: Rails.cache, clock: -> { Time.current })
    @cache = cache
    @clock = clock
  end

  def allowed?(ip:, limit:)
    count = @cache.increment(cache_key(ip), 1, expires_in: WINDOW)
    count <= limit
  end

  private

  attr_reader :cache, :clock

  def cache_key(ip)
    "public-rate-limit:#{ip}:#{clock.call.to_i / WINDOW.to_i}"
  end
end
