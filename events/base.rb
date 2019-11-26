module Event
  module Base
    def initialize client_pool
      @client_pool = client_pool
    end

    def dispatch message
      raise NotImplementedError
    end
  end
end
