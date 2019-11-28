require_relative 'base'

module Event
  class Broadcast
    include ::Event::Base

    # Notify all clients connected in the @client_pool
    #
    # @param message [Message] instance of Message to be processed
    def process message
      @client_pool.broadcast(message)
    end
  end
end
