require_relative 'base'

module Event
  class Broadcast
    include ::Event::Base

    def process message
      @client_pool.values.each do |socket|
        socket.puts(message.raw)
        socket.flush
      end
    end
  end
end
