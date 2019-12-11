require_relative "#{ROOT_DIR}/models/message"
require_relative "#{ROOT_DIR}/services/event_dispatcher"

module SocketHandler
  class EventSocketHandler
    def initialize events_queue, client_pool, follow_registry, dlq
      @events_queue,
      @client_pool,
      @follow_registry,
      @dlq = events_queue, client_pool, follow_registry, dlq
    end

    def process socket
      socket.each_line do |payload|
        App.log.debug "<incoming payload>: #{payload.chomp}"

        message = ::Message.new payload

        if message.valid?
          App.log.debug "<adding valid message to events_queue>: #{payload.chomp}"
          @events_queue.add message
        else
          App.log.warn "(#{message.to_str.chomp}) ⎇ [Bad Format]: event added to DLQ"
          @dlq.add message, :bad_message_format
        end
      end

      dispatcher = ::EventDispatcher.new @events_queue, @client_pool, @follow_registry
      dispatcher.run

      puts "Dead Letters Report:"
      puts "==================="
      puts JSON.pretty_generate(@dlq.report)

      socket.close
    end
  end
end
