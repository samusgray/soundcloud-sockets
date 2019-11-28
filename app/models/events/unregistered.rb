require_relative 'base'

module Event
  class Unregistered
    include Event::Base

    def process message
      @dlq.add message, :unregistered_event
    end
  end
end
