require_relative 'base'

module Event
  class PrivateMessage
    include Event::Base

    def process message
      @client_pool.notify message.target, message
    end
  end
end
