module Event
  class Unregistered
    def process
      puts "~unregistered event~"
    end

    def kinnd
      nil
    end
  end
end
