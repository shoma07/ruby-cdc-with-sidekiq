# frozen_string_literal: true

redis_config = {
  url: ENV.fetch('REDIS_URL'),
  network_timeout: ENV.fetch('REDIS_NETWORK_TIMEOUT', 5).to_i
}

Sidekiq.configure_client do |config|
  config.redis = redis_config
end

Sidekiq.configure_server do |config|
  config.redis = redis_config
end
