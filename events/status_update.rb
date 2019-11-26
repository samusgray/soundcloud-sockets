require_relative 'base'

module Event
  class StatusUpdate
    include Event::Base

    def dispatch message
      actor     = message.actor
      followers = actor.followers
      puts "actor.id"
      puts actor.id
      puts "actor.followers"
      puts actor.followers
      followers.each do |follower_id|
        puts socket
        socket = @client_pool[follower_id]

        if socket
          socket.puts(message.to_str)
          socket.flush
        end
      end
    end
  end
end
