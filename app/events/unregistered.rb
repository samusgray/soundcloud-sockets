require_relative 'base'

module Event
  class Unregistered
    include Event::Base

    def process message
      puts "Unregistered event: #{message.to_str}"
    end
  end
end
