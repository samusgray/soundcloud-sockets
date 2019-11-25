require_relative 'base'

module Event
  class Unregistered
    include Event::Base

    def process payload
      puts "~~~~private message!"
      puts payload
    end
  end
end
