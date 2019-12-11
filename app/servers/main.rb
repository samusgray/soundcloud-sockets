require_relative 'socket_server'
require_relative "#{ROOT_DIR}/models/client_pool"
require_relative "#{ROOT_DIR}/services/queues/events_queue"
require_relative "#{ROOT_DIR}/services/queues/dead_letter_queue"
require_relative "#{ROOT_DIR}/services/sockets/client_handler"
require_relative "#{ROOT_DIR}/services/sockets/event_handler"

class Server
  def initialize
    @follow_registry = {}
    @events_queue    = EventsQueue.new
    @dlq             = DLQ.new
    @client_pool     = ClientPool.new @dlq

    Thread.abort_on_exception = true
  end

  def self.run
    new().run
  end

  def run
    client_handler = SocketHandler::ClientSocketHandler.new @client_pool
    event_handler  = SocketHandler::EventSocketHandler.new @events_queue, @client_pool, @follow_registry, @dlq

    event_socket_server = SocketServer.new(event_handler).run(
      "Listening for events on #{::APP_CONFIG['EVENT_PORT']}",
      ::APP_CONFIG['EVENT_PORT']
    )
    client_socket_server = SocketServer.new(client_handler).run(
      "Listening for client requests on #{::APP_CONFIG['CLIENT_PORT']}",
      ::APP_CONFIG['CLIENT_PORT']
    )

    [event_socket_server, client_socket_server].map(&:join)
  end
end
