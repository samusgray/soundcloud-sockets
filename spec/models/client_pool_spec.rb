require 'spec_helper'
require 'pry'

require_relative "#{ROOT_DIR}/app/models/client_pool"

describe 'ClientPoolQueue' do
  context '.add' do
    it 'Add single client / socket pair to clients hash' do
      pool = client_pool

      pool.add 1, {}

      expect(pool.size).to eq (1)
    end

    it 'does not add duplicates' do
      pool = client_pool

      pool.add 1, {}
      pool.add 1, {}

      expect(pool.size).to eq (1)
    end

    it 'does store multiple' do
      pool = client_pool

      pool.add 1, {}
      pool.add 2, {}

      expect(pool.size).to eq (2)
    end
  end

  context '.notify' do
    context 'when client is not found' do
      it 'adds message to DLQ' do
        dlq = spy('dlq')
        pool = client_pool(dlq)
        message = Message.new('666|F|60|50')

        pool.add 1, {}
        pool.notify 2, message

        expect(dlq).to have_received(:add)
      end
    end

    context 'when client is found' do
      it 'does not add message to DLQ' do
        dlq     = spy('dlq')
        socket  = spy('socket')
        pool    = client_pool(dlq)
        message = Message.new('666|F|60|50')

        pool.add 1, socket
        pool.notify 1, message

        expect(dlq).to_not have_received(:add)
        expect(socket).to have_received(:puts)
      end
    end

  end

  private

  def client_pool dlq=spy('dlq')
    ClientPool.new(dlq)
  end
end
