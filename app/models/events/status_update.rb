require_relative 'base'

module Event
  class StatusUpdate
    include Event::Base

    # Notify all followers from @follow_registry
    #
    # @param message [Message] instance of Message to be processed
    def process message
      followers = @follow_registry[message.actor] || Set.new

      App.log.info "(#{message.to_str.chomp}) → [StatusUpdate]: Published by Client ID #{message.actor} to #{followers.count} followers"

      followers.each do |follower|
        @client_pool.notify follower, message
      end
    end
  end
end
