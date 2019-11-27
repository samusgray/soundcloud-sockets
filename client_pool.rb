class ClientPool
  def initialize events_queue
    @events_queue = events_queue
    @connected_clients = {}
  end

  def add(client_id, socket)
    @connected_clients[client_id] = socket
  end

  def size
    @connected_clients.keys.length
  end

  def notify(client_id, message)
    if !@connected_clients.has_key? client_id
      puts "Adding message to dead letter queue #{message.to_str}"

      @events_queue.add message
    else
      begin
        @connected_clients[client_id].puts message.to_str
      rescue StandardError => e
        @connected_clients.delete client_id
        puts "boooop"
        puts e
      end
    end
  end

  def broadcast(message)
    @connected_clients.keys.each do |key|
      puts "boop"
      notify(key, message)
    end
  end
end
