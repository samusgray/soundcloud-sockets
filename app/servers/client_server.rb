class ClientServer
  def initialize client_pool
    @client_pool = client_pool
  end

  def run
    Thread.new do
      puts "Listening for client requests on #{::APP_CONFIG['CLIENT_PORT']}"
      server = TCPServer.open ::APP_CONFIG['CLIENT_PORT']

      loop do
        Thread.fork(server.accept) { |socket| socket_handler(socket) }
      end
    end
  end

  private

  def socket_handler socket
    user_id_string = socket.gets

    if user_id_string
      user_id = user_id_string.to_i

      @client_pool.add user_id, socket

      puts "User connected: #{user_id} (#{@client_pool.size} total)"
    end
  end
end
