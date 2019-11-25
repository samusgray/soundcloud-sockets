require_relative 'base'

module Event
  class PrivateMessage
    include Event::Base

    def initialize client_pool, follow_registry
      @client_pool = client_pool
    end

    def process message
      socket = @client_pool[message.target]
      if socket
        socket.puts(message.raw)
        socket.flush
      end
    end
  end
end
