class Message
  def initialize payload
    payload_parts = payload.split('|')
    # todo validations

    @raw      = payload
    @sequence = payload_parts[0]
    @kind     = payload_parts[1]
    @actor    = payload_parts[2]
    @target   = payload_parts[3]
  end

  attr_reader :raw

  def sequence
    @sequence.to_i
  end

  def kind
    @kind.to_sym
  end

  def actor
    @actor.to_i if @actor
  end

  def target
    @target.to_i if @target
  end
end
