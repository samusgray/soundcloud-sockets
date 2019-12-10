require 'spec_helper'
require_relative '../../app/models/message'
require_relative '../../app/services/queues/events_queue'

describe 'EventsQueue' do
  context '.add' do
    it 'stores the message' do
      message = Message.new '0|F|1|2'
      events_queue = EventsQueue.new
      events_queue.add message

      expect(events_queue.size).to be 1
    end

    it 'does not store dulplicates' do
      message = Message.new '0|F|1|2'
      duplicate_message = Message.new '0|F|1|2'

      events_queue = EventsQueue.new
      events_queue.add message
      events_queue.add duplicate_message

      expect(events_queue.size).to be 1
    end

    it 'stores unique messages' do
      message = Message.new '0|F|1|2'
      second_message = Message.new '1|F|1|2'
      events_queue = EventsQueue.new

      events_queue.add message
      events_queue.add second_message

      expect(events_queue.size).to be 2
    end
  end

  context '.remove' do
    it 'removes message from storage' do
      message = Message.new '0|F|1|2'
      events_queue = EventsQueue.new
      events_queue.add message
      events_queue.remove message

      expect(events_queue.size).to be 0
    end
  end

  context '.next_event' do
    it 'returns next message based on sequence number' do
      first  = Message.new '0|F|9|10'
      second = Message.new '1|F|9|10'
      third  = Message.new '2|F|9|10'

      events_queue = EventsQueue.new
      events_queue.add first
      events_queue.add second
      events_queue.add third

      result = events_queue.next_event second

      expect(result.sequence).to be 2
    end
  end
end
