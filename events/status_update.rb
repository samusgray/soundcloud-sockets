module Event
  class StatusUpdate
    def process
      puts "~~~~status update!"
    end

    def kind
      "S"
    end
  end
end
