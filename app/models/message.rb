class Message
  # Abstraction for incoming messages. There are five possible messages
  # which corespond to events.
  #
  # Params:
  # +payload+:: +String+ of raw data sent over the socket using
  #
  # The table below describes +payload+ strings and what each represents:
  #
  #
  # | +payload+     | @sequence  | @kind         | @actor       | @target    |
  # |---------------|------------|---------------|--------------|------------|
  # | 666|F|60|50   | 666        | Follow        | 60           | 50         |
  # | 1|U|12|9      | 1          | Unfollow      | 12           | 9          |
  # | 542532|B      | 542532     | Broadcast     | -            | -          |
  # | 43|P|32|56    | 43         | Private Msg   | 32           | 56         |
  # | 634|S|32      | 634        | Status Update | 32           | -          |
  #

  def initialize payload
    # Ignore message payloads that do not minimally
    # match '[sequence number]|[kind]' format.
    @valid = VALID_REGEX.match(payload)

    payload_parts = payload.split '|'

    @raw      = payload
    @sequence = payload_parts[0]
    @kind     = payload_parts[1]
    @actor    = payload_parts[2]
    @target   = payload_parts[3]
  end

  # Origonal payload from event source.
  #
  # @return [String] the string representation of payload.
  def to_str
    @raw
  end

  def valid?
    !@valid.nil?
  end

  # Adds sorting functionality used by [DeadLetterQueue](app/services/queues/dead_letter_queue.rb)
  # to store failed message ordered by sequence number.
  #
  # @return [Bool] true or false comparing self with another message's sequence number.
  def <=>(message)
    self.sequence <=> message.sequence
  end

  # Sequence number from payoad
  #
  # @return [Int] the payload sequence number converted to integer.
  def sequence
    @sequence.to_i
  end

  # Sequence number plus one for sequencing in EventDispatcher
  #
  # @return [Int]
  def next_sequence
    @sequence.to_i + 1
  end

  # The kind of message may be F, U, B, S, or P. See table above.
  #
  # @return [Symbol] :F, :U, :B, :S, or :P
  def kind
    @kind.chomp.to_sym
  end


  # The account ID of the acting user.
  #
  # @return [Int] The ID of acting user if present.
  def actor
    @actor.to_i if @actor
  end

  # The account ID of the target user.
  #
  # @return [Int] The ID of target user if present.
  def target
    @target.to_i if @target
  end

  private

  VALID_REGEX = /^(\d+)\|([A-Z]+)/
end
