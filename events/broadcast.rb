require_relative 'base'

module Event
  class Broadcast
    include ::Event::Base

    def process message
      @client_pool.broadcast(message)
    end
  end
end
