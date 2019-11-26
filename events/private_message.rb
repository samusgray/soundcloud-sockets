require_relative 'base'

module Event
  class PrivateMessage
    include Event::Base

    def dispatch message
      socket = @client_pool[message.target.id]

      if socket
        socket.puts(message.to_str)
        socket.flush
      end
    end
  end
end
