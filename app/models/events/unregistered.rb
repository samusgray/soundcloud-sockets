require_relative 'base'

module Event
  class Unregistered
    include Event::Base

    # Catch all unregistered events and add them to DeadLetterQueue
    #
    # @param message [Message] instance of Message to be added to DLQ
    def process message
      @dlq.add message, :unregistered_event
    end
  end
end
