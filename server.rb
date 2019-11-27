require_relative 'events_queue'
require_relative 'client_pool'

class Server
  def initialize
    @seq_no_to_message = {}
    @follow_registry = {}

    @guard_message = Message.new('0|Guard')
    @events_queue = EventsQueue.new
    @client_pool = ClientPool.new @events_queue
  end

  def self.run
    new().run
  end

  def run
    thread1 = Thread.new do
      puts("Listening for events on #{::APP_CONFIG['EVENT_PORT']}")
      client_server = TCPServer.open(::APP_CONFIG['EVENT_PORT'])

      loop do
        Thread.fork(client_server.accept) { |socket| event_thread(socket) }
      end
    end

    thread2 = Thread.new do
      puts("Listening for client requests on #{::APP_CONFIG['CLIENT_PORT']}")
      client_server = TCPServer.open(::APP_CONFIG['CLIENT_PORT'])
      loop do
        Thread.fork(client_server.accept) { |socket| client_thread(socket) }
      end
    end

    thread1.join
    thread2.join
  end

  def event_thread socket
    socket.each_line do |payload|
      @events_queue.add Message.new payload

      while next_message = @events_queue.next_event(@guard_message)

        event_handler = EVENT_HANDLERS[next_message.kind]

        event = event_handler.new @client_pool, @follow_registry

        event.process next_message

        @guard_message = next_message
        @events_queue.remove next_message
      end
    end

    socket.close
  end

  def client_thread socket
    user_id_string = socket.gets

    if user_id_string
      user_id = user_id_string.to_i

      @client_pool.add user_id, socket

      puts("User connected: #{user_id} (#{@client_pool.size} total)")
    end
  end
end
