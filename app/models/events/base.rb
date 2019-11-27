module Event
  module Base
    def initialize client_pool, follow_registry
      @client_pool, @follow_registry = client_pool, follow_registry
    end

    def process message
      raise NotImplementedError, "Impliment this method in a class that includes Base"
    end
  end
end
