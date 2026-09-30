# Keeps the Landing Page attribute allow list in one place, shared by the HTTP
# controller and the MCP tools, so neither can drift from the other.
class LandingPageAttributeFilter
  PERMITTED_KEYS = %w[name current_data allowed_hosts].freeze

  # With allow_partial, only the keys actually present are returned, which is what
  # an update needs. Without it, every permitted key is returned, present or not.
  def self.call(attributes, allow_partial: false)
    keys = allow_partial ? attributes.keys : PERMITTED_KEYS

    keys.each_with_object({}) do |key, permitted|
      permitted[key.to_sym] = attributes[key] if PERMITTED_KEYS.include?(key.to_s)
    end
  end
end
