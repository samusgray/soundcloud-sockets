require_relative 'base'

module Event
  class Unfollow
    include Event::Base

    # Remove follower and do not notify +message.target+
    #
    # @param message [Message] instance of Message to be processed
    def process message
      App.log.info "(#{message.to_str.chomp}) → [Unfollow]: Client ID #{message.actor} unfollowed Client ID #{message.target}"

      to_user_id = message.target

      followers = @follow_registry[to_user_id] || Set.new

      followers.delete(message.actor)

      @follow_registry[to_user_id] = followers
    end
  end
end
