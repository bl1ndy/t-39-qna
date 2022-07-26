require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module QnA
  class Application < Rails::Application
    config.load_defaults 6.1

    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.generators do |g|
      g.test_framework :rspec,
                       controller_specs: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false
    end
  end
end
