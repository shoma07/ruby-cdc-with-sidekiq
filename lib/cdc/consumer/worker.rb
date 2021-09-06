require 'sidekiq'

module CDC
  module Consumer
    # CDC::Consumer::Worker
    class Worker
      include Sidekiq::Worker

      def perform(events)
        p events
      end
    end
  end
end
