require_relative 'models/client_pool'
require_relative 'queues/events_queue'
require_relative 'queues/dead_letter_queue'
require_relative 'servers/event_server'
require_relative 'servers/client_server'

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
    [
      EventServer.new(@events_queue, @client_pool, @follow_registry, @dlq).run,
      ClientServer.new(@client_pool).run
    ].map(&:join)
  end
end
