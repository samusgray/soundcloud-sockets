require_relative 'base'

module Event
  class Broadcast
    include ::Event::Base

    # Notify all clients connected in the @client_pool
    #
    # @param message [Message] instance of Message to be processed
    def process message
      App.log.info "(#{message.to_str.chomp}) → [Broadcast]: Made by Client ID #{message.actor}"

      @client_pool.broadcast(message)
    end
  end
end
