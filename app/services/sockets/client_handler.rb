module SocketHandler
  class ClientSocketHandler
    def initialize client_pool
      @client_pool = client_pool
    end

    def process socket
      user_id_string = socket.gets

      if user_id_string
        user_id = user_id_string.to_i

        @client_pool.add user_id, socket

        puts "User connected: #{user_id} (#{@client_pool.size} total)"
      end
    end
  end
end
