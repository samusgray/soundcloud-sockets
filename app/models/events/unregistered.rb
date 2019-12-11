require_relative 'base'

module Event
  class Unregistered
    include Event::Base

    # Catch all unregistered events and add them to DeadLetterQueue
    #
    # @param message [Message] instance of Message to be added to DLQ
    def process message
      App.log.warn "(#{message.to_str.chomp}) ⎇ [Unregistered]: event added to DLQ"

      @client_pool.dlq.add message, :unregistered_event
    end
  end
end
