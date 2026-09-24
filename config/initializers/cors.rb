origins = ENV.fetch("LPDATA_CORS_ORIGINS", "").split(",").map(&:strip).reject(&:empty?)

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(*origins)

    resource "/api/*",
      headers: %w[Authorization Content-Type],
      methods: %i[get post delete options],
      expose: %w[Authorization],
      max_age: 600
  end
end
