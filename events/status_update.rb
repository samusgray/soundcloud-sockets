require_relative 'base'

module Event
  class StatusUpdate
    include Event::Base

    def process message
      followers = @follow_registry[message.actor] || Set.new

      followers.each do |follower|
        @client_pool.notify follower, message
      end
    end
  end
end
