require_relative 'base'

module Event
  class StatusUpdate
    include Event::Base

    def process message
      from_user_id = message.actor

      followers = @follow_registry[from_user_id] || Set.new
      followers.each do |follower|
        socket = @client_pool[follower]

        if socket
          socket.puts(message.to_string)
          socket.flush
        end
      end
    end
  end
end
