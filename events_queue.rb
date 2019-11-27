class EventsQueue
  def initialize
    @events = {}
  end

  def add message
    @events[message.sequence] = message
  end

  def remove message
    @events.delete message.sequence
  end

  def size
    @events.keys.length
  end

  def next_event message
    return nil if !@events.has_key? message.next_sequence
    @events[message.next_sequence]
  end
end
