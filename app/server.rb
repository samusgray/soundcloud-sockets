require_relative 'queues/events_queue'
require_relative 'queues/dead_letter_queue'
require_relative 'events/event_dispatcher'
require_relative 'client_pool'

class Server
  def initialize
    @follow_registry = {}
    @events_queue    = EventsQueue.new
    @dlq             = DLQ.new
    @client_pool     = ClientPool.new @dlq
  end

  def self.run
    new().run
  end

  def run
    thread1 = Thread.new do
      puts "Listening for events on #{::APP_CONFIG['EVENT_PORT']}"
      client_server = TCPServer.open ::APP_CONFIG['EVENT_PORT']

      loop do
        Thread.fork(client_server.accept) { |socket| event_thread(socket) }
      end
    end

    thread2 = Thread.new do
      puts "Listening for client requests on #{::APP_CONFIG['CLIENT_PORT']}"
      client_server = TCPServer.open ::APP_CONFIG['CLIENT_PORT']

      loop do
        Thread.fork(client_server.accept) { |socket| client_thread(socket) }
      end
    end

    thread1.join
    thread2.join
  end

  private

  def event_thread socket
    socket.each_line do |payload|
      @events_queue.add Message.new payload
    end

    dispatcher = EventDispatcher.new @events_queue, @client_pool, @follow_registry
    dispatcher.run

    socket.close
  end

  def client_thread socket
    user_id_string = socket.gets

    if user_id_string
      user_id = user_id_string.to_i

      @client_pool.add user_id, socket

      puts "User connected: #{user_id} (#{@client_pool.size} total)"
    end
  end
end
