require_relative 'base'

module Event
  class Follow
    include Event::Base

    def dispatch message
      target = message.target
      actor  = message.actor

      target.register_follower(actor.id)
      socket = @client_pool[target.id]

      if socket
        socket.puts(message.to_str)
        socket.flush
      end
    end
  end
end
