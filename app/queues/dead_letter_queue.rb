#
# * Malformed messages
# * UnregisteredEvent
# * Client not connected

require_relative '../models/event_dispatcher'

class DLQ
  # Storage for messages sent to unreachable clients
  #
  # Implimented as a hash table of failed message stored in the appropriate
  # category and orderd by sequence number.
  #
  # For example:
  #
  # {
  #   bad_message_format:          <SortedSet { [Message @kind='F', sequence=1], [Message @kind='B', sequence=2] >,
  #   unregistered_event:   <SortedSet { [Message @kind='S', sequence=5], [Message @kind='U', sequence=6] >,
  #   client_not_reachable: <SortedSet { [Message @kind='B', sequence=3], [Message @kind='S', sequence=4] >,
  # }
  def initialize
    @queue = {
      bad_message_format: SortedSet.new,
      unregistered_event: SortedSet.new,
      client_not_reachable: SortedSet.new,
    }

    # EventDispatcher::EVENT_HANDLERS.keys.each do |key|
    #   @queue[key] = SortedSet.new
    # end
  end

  def size
    queue_size = {}
    @queue.keys.map do |key|
      queue_size[key] = @queue[key].size
    end
    queue_size
  end

  attr_reader :queue

  def add message, reason
    @queue[reason] << message
  end
end
