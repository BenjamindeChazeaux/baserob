
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'

    resource '/requests',
      headers: :any,
      methods: [:post, :options],
      credentials: false,
      max_age: 86400
  end
end
