require_relative '../models/message'
require_relative '../services/event_dispatcher'

class EventServer
  def initialize events_queue, client_pool, follow_registry, dlq
    @events_queue    = events_queue
    @client_pool     = client_pool
    @follow_registry = follow_registry
    @dlq             = dlq
  end

  def run
   Thread.new do
      puts "Listening for events on #{::APP_CONFIG['EVENT_PORT']}"
      server = TCPServer.open ::APP_CONFIG['EVENT_PORT']

      loop do
        Thread.fork(server.accept) { |socket| socket_handler(socket) }
      end
    end
  end

  private

  def socket_handler socket
    socket.each_line do |payload|
      message = Message.new payload
      if message.valid?
        @events_queue.add message
      else
        @dlq.add message, :bad_message_format
      end
    end

    dispatcher = EventDispatcher.new @events_queue, @client_pool, @follow_registry, @dlq
    dispatcher.run

    puts "Dead Letters Report:"
    puts "==================="
    puts JSON.pretty_generate(@dlq.report)

    socket.close
  end
end
