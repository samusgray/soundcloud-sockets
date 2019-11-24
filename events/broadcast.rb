module Event
  class Broadcast
    def process
      puts "~~~~broadcast!"
    end

    def kind
      "B"
    end
  end
end
