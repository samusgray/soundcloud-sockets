require_relative 'base'

module Event
  class Follow
    include Event::Base

    def initialize client_pool, follow_registry
      @client_pool = client_pool
      @follow_registry = follow_registry
    end

    def process message
      to_user_id = message.target

      followers = @follow_registry[to_user_id] || Set.new
      followers << message.actor
      @follow_registry[to_user_id] = followers

      socket = @client_pool[to_user_id]
      if socket
        socket.puts(message.to_string)
        socket.flush
      end
    end
  end
end
