origins = ENV.fetch("LPDATA_CORS_ORIGINS", "").split(",").map(&:strip).reject(&:empty?)

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(*origins)

    %w[/auth/* /manage/* /assets /assets/*].each do |path|
      resource path,
        headers: %w[Authorization Content-Type],
        methods: %i[get post patch delete options],
        expose: %w[Authorization],
        max_age: 600
    end
  end

  allow do
    origins "*"

    resource "/landing_pages/*",
      headers: "*",
      methods: %i[get options],
      max_age: 600
  end
end
