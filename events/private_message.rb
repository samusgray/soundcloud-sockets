module Event
  class PrivateMessage
    def process
      puts "~~~~private message!"
    end

    def kind
      "P"
    end
  end
end
