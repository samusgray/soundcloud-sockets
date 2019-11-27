require_relative '../events/event_dispatcher'

class DLQ
  def initialize
    @queue = {}

    EventDispatcher::EVENT_HANDLERS.keys.each do |key|
      @queue[key] = SortedSet.new
    end
  end

  def add message
    @queue[message.kind] << message
  end
end
