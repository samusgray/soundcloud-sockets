require_relative 'user'

class Message
  def initialize payload
    payload_parts = payload.split('|')
    # todo validations

    @raw      = payload
    @sequence = payload_parts[0]
    @kind     = payload_parts[1]
    @actor    = User.new(payload_parts[2])
    @target   = User.new(payload_parts[3])

    puts @raw
  end

  def to_str
    @raw
  end

  def sequence
    @sequence.to_i
  end

  def kind
    @kind.to_sym
  end

  def actor
    @actor
  end

  def target
    @target
  end
end
