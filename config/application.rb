require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module StockApi
  class Application < Rails::Application
    config.load_defaults 7.0

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'

        resource '*',
                 headers: :any,
                 methods: %i[get post delete put patch]
      end
    end
    config.api_only = true
  end
end
