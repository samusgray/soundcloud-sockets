require 'spec_helper'
require_relative '../../app/models/message'
require_relative '../../app/queues/dead_letter_queue'

describe 'Message' do
  context '.valid?' do
    it 'marks malformatted strings' do
      good   = Message.new '0|B'
      bad_a  = Message.new '1B'
      bad_b  = Message.new '|B'

      expect(good.valid?).to be  true
      expect(bad_a.valid?).to be false
      expect(bad_b.valid?).to be false
    end
  end

  context '.to_str' do
    it 'returns the raw string of the event' do
      message = Message.new('0|F|23|42')

      expect(message.to_str).to eq '0|F|23|42'
    end
  end

  context '.sequence' do
    it 'returns the sequence number' do
      message = Message.new('0|F|23|42')

      expect(message.sequence).to eq 0
    end
  end

  context '.next_sequence' do
    it 'returns the sequence number plus one' do
      message = Message.new('0|F|23|42')

      expect(message.next_sequence).to eq 1
    end
  end

  context '.<=>' do
    it 'compares sequence number' do
      message_a   = Message.new('0|F|23|42')
      message_b  = Message.new('1|F|23|42')

      expect(message_a <=> message_b).to eq -1
      expect(message_b <=> message_a).to eq 1
    end
  end

  context '.kind' do
    it 'returns message kind' do
      follow     = Message.new('0|F|23|42')
      broadcast  = Message.new('1|B')

      expect(follow.kind).to eq :F
      expect(broadcast.kind).to eq :B
    end
  end

  context '.actor' do
    it 'returns actor ID' do
      message_with_actor    = Message.new('0|F|23|42')
      message_without_actor = Message.new('0|B')

      expect(message_with_actor.actor).to eq 23
      expect(message_without_actor.actor).to eq nil
    end
  end

  context '.target' do
    it 'returns target ID' do
      message_with_target    = Message.new('0|F|23|42')
      message_without_target = Message.new('0|B')

      expect(message_with_target.target).to eq 42
      expect(message_without_target.target).to eq nil
    end
  end
end



# def initialize payload
#     # Ignore message payloads that do not minimally
#     # match '[sequence number]|[kind]' format.
#     @valid = VALID_REGEX.match(payload)

#   # The account ID of the acting user.
#   #
#   # @return [Int] The ID of acting user if present.
#   def actor
#     @actor.to_i if @actor
#   end

#   # The account ID of the target user.
#   #
#   # @return [Int] The ID of target user if present.
#   def target
#     @target.to_i if @target
#   end

#   private

#   VALID_REGEX = /^(\d+)\|([A-Z]+)/
# end
