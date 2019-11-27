require_relative '../models/event_dispatcher'

class DLQ
  # Storage for messages sent to unreachable clients
  #
  # Implimented as a hash table of message kinds with messages
  # stored in the appropriate kind and orderd by sequence number.
  #
  # For example:
  #
  # {
  #   F: <SortedSet { [Message @kind='F', sequence=1], [Message @kind='F', sequence=2] >,
  #   U: <SortedSet { [Message @kind='U', sequence=5], [Message @kind='U', sequence=6] >,
  #   S: <SortedSet { [Message @kind='S', sequence=3], [Message @kind='S', sequence=4] >,
  #   P: <SortedSet { [Message @kind='P', sequence=10], [Message @kind='P', sequence=15] >,
  #   B: <SortedSet { [Message @kind='B', sequence=11], [Message @kind='P', sequence=12] >,
  # }
  def initialize
    @queue = {}

    EventDispatcher::EVENT_HANDLERS.keys.each do |key|
      @queue[key] = SortedSet.new
    end
  end

  def add message
    @queue[message.kind] << message
    puts "added to DLQ: #{message.to_str}"
  end
end
