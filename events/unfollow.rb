module Event
  class Unfollow
    def process
      puts "~~~~unfollow!"
    end

    def kind
      "U"
    end
  end
end
