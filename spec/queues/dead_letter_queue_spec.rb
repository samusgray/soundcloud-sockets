require 'spec_helper'
require_relative '../../app/models/message'
require_relative '../../app/queues/dead_letter_queue'

describe 'DLQ' do
  context '.add' do
    it 'store events by category' do
      q = DLQ.new
      message = Message.new '0|F|1|2'

      q.add message, :bad_message_format
      q.add message, :unregistered_event
      q.add message, :client_not_reachable

      expect(q.report[:bad_message_format]).to be 1
      expect(q.report[:unregistered_event]).to be 1
      expect(q.report[:client_not_reachable]).to be 1
    end

    it 'does not store duplicates in category' do
      q = DLQ.new
      message = Message.new '0|F|1|2'

      q.add message, :bad_message_format
      q.add message, :bad_message_format

      expect(q.report[:bad_message_format]).to be 1
    end

    it 'rejects bad categories' do
      q = DLQ.new
      message = Message.new '0|F|1|2'

      q.add message, :did_not_enjoy_message

      expect(q.report[:did_not_enjoy_message]).to be nil
    end
  end
end
