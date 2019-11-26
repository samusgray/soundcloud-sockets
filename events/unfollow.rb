require_relative 'base'

module Event
  class Unfollow
    include Event::Base

    def dispatch message
      target = message.target
      actor = message.actor

      target.unregister_follower(actor)
    end
  end
end
