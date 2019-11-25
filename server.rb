class Server
  def initialize
    @client_pool = {}
    @seq_no_to_message = {}
    @follow_registry = {}
    @last_seq_no = 0
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
      message = Message.new(payload)

      @seq_no_to_message[message.sequence] = message

      while @seq_no_to_message[@last_seq_no + 1]
        next_message = @seq_no_to_message[@last_seq_no + 1]

        event_handler = EVENT_HANDLERS[next_message.kind]

        event = event_handler.new(
          @client_pool, @follow_registry
        )

        puts next_message.to_string
        event.process(next_message)

        @last_seq_no = next_message.sequence
      end
    end

    socket.close
  end

  def client_thread socket
    user_id_string = socket.gets

    if user_id_string
      user_id = user_id_string.to_i
      @client_pool[user_id] = socket
      puts("User connected: #{user_id} (#{@client_pool.size} total)")
    end
  end
end
