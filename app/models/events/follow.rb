require_relative 'base'

module Event
  class Follow
    include Event::Base

    def process message
      to_user_id = message.target

      followers = @follow_registry[to_user_id] || Set.new
      followers << message.actor
      @follow_registry[to_user_id] = followers

      @client_pool.notify to_user_id, message
    end
  end
end
