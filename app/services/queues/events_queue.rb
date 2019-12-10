class EventsQueue
  # Storage for events needed for processing
  def initialize
    @events = {}
  end

  # Add event to be processed
  #
  # @param [Message] the message to be added
  def add message
    @events[message.sequence] = message
  end

  # Add event to be processed
  #
  # @param [Message] the message to be removed
  def remove message
    @events.delete message.sequence
  end

  # Size of event queue
  #
  # @return [Int] the number of events in the queue
  def size
    @events.keys.length
  end

  # Next message based on sequence
  #
  # @param [Message] the previous message
  # @return [Message] the next message in the queue, if present
  def next_event message
    return nil if !@events.has_key? message.next_sequence
    @events[message.next_sequence]
  end
end
