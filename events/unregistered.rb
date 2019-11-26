require_relative 'base'

module Event
  class Unregistered
    include Event::Base

    def dispatch message
      puts message
    end
  end
end
