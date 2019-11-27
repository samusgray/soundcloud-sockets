module Event
  module Base
    def initialize client_pool, follow_registry
      @client_pool, @follow_registry = client_pool, follow_registry
    end

    def process payload
      raise NotImplementedError
    end
  end
end
