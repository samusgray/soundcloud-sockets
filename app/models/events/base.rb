module Event
  module Base
    def initialize client_pool, follow_registry, dlq
      @client_pool, @follow_registry, @dlq = client_pool, follow_registry, dlq
    end

    def process message
      raise NotImplementedError, "Impliment this method in a class that includes Base"
    end
  end
end
