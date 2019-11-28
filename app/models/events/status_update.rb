require_relative 'base'

module Event
  class StatusUpdate
    include Event::Base

    # Notify all followers from @follow_registry
    #
    # @param message [Message] instance of Message to be processed
    def process message
      followers = @follow_registry[message.actor] || Set.new

      followers.each do |follower|
        @client_pool.notify follower, message
      end
    end
  end
end
