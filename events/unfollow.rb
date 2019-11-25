require_relative 'base'

module Event
  class Unfollow
    include Event::Base

    def process message
      to_user_id = message.target

      followers = @follow_registry[to_user_id] || Set.new

      followers.delete(message.actor)

      @follow_registry[to_user_id] = followers
    end
  end
end
