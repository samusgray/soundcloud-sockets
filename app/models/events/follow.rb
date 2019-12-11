require_relative 'base'

module Event
  class Follow
    include Event::Base

    # Only notify +message.target+
    #
    # @param message [Message] instance of Message to be processed
    def process message
      App.log.info "(#{message.to_str.chomp}) → [Follow]: Request sent from Client ID #{message.actor} to Client ID #{message.target}"

      to_user_id = message.target

      followers = @follow_registry[to_user_id] || Set.new
      followers << message.actor
      @follow_registry[to_user_id] = followers

      @client_pool.notify to_user_id, message
    end
  end
end
