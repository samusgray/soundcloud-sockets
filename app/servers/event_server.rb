require_relative "#{ROOT_DIR}/models/message"
require_relative "#{ROOT_DIR}/services/event_dispatcher"

class EventServer
  def initialize events_queue, client_pool, follow_registry, dlq
    @events_queue    = events_queue
    @client_pool     = client_pool
    @follow_registry = follow_registry
    @dlq             = dlq
  end

  def run
    App.log.info "Listening for events on #{::APP_CONFIG['EVENT_PORT']}", :green
    server = TCPServer.open ::APP_CONFIG['EVENT_PORT']

    Thread.new do
      loop do
        Thread.fork(server.accept) { |socket| socket_handler(socket) }
      end
    end
  end

  private

  def socket_handler socket
    socket.each_line do |payload|
      App.log.debug "<incoming payload>: #{payload.chomp}"

      message = Message.new payload

      if message.valid?
        App.log.debug "<adding valid message to events_queue>: #{payload.chomp}"
        @events_queue.add message
      else
        App.log.warn "(#{message.to_str.chomp}) ⎇ [Bad Format]: event added to DLQ"
        @dlq.add message, :bad_message_format
      end
    end

    dispatcher = EventDispatcher.new @events_queue, @client_pool, @follow_registry
    dispatcher.run

    puts "Dead Letters Report:"
    puts "==================="
    puts JSON.pretty_generate(@dlq.report)

    socket.close
  end
end
