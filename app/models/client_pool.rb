class ClientPool
  # Stores and notifies connected clients
  #
  # Params:
  # +dlq+:: [DeadLetterQueue] to store messages for unreachable clients
  # +clients+:: [Hash] object to store reference to all connected clients

  def initialize dlq
    @dlq = dlq
    @clients = {}
  end

  # Add single client / socket pair to clients hash
  #
  # @param client_id [Int] the id of connected client
  # @param socket [Socket] of connected client
  def add client_id, socket
    @clients[client_id] = socket
  end

  # Number of clients in pool
  #
  # @return [Int] the number of clients in pool
  def size
    @clients.keys.length
  end

  # Notify specific client in pool
  #
  # @param client_id [Int] the client to notify
  # @param message [Message] the message to send
  def notify client_id, message
    if !@clients.has_key? client_id
      App.log.warn "(#{message.to_str.chomp}) ⎇ added to DLQ"

      @dlq.add message, :client_not_reachable
      @clients.delete client_id
    else
      App.log.info "(#{message.to_str.chomp}) ⌲⌲⌲⌲⌲⌲ Notification sent!", :green
      @clients[client_id].puts message.to_str
    end
  end

  # Notify all active clients in pool
  #
  # @param message [Message] the message to send all clients
  def broadcast message
    @clients.keys.each do |key|
      notify key, message
    end
  end
end
