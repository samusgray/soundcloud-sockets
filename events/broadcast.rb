require_relative 'base'

module Event
  class Broadcast
    include ::Event::Base

    def dispatch message
      @client_pool.values.each do |socket|
        socket.puts(message.to_str)
        socket.flush
      end
    end
  end
end
