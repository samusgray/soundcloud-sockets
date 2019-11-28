require_relative 'base'

module Event
  class PrivateMessage
    include Event::Base

    # Only notify +message.target+
    #
    # @param message [Message] instance of Message to be processed
    def process message
      @client_pool.notify message.target, message
    end
  end
end
