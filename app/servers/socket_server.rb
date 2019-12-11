class SocketServer
  def initialize socket_handler
    @socket_handler = socket_handler
  end

  def run log_message, port
    App.log.info log_message, :green
    server = TCPServer.open port

    Thread.new do
      loop do
        Thread.fork(server.accept) { |socket| @socket_handler.process(socket) }
      end
    end
  end
end
