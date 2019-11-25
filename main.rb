require 'set'
require 'socket'

require_relative 'message'
require_relative 'events/broadcast'
require_relative 'events/follow'
require_relative 'events/private_message'
require_relative 'events/status_update'
require_relative 'events/unfollow'
require_relative 'events/unregistered'

EVENT_PORT = 9090
CLIENT_PORT = 9099

client_pool = {}
seq_no_to_message = {}
follow_registry = {}
last_seq_no = 0

EVENT_HANDLERS = Hash.new(Event::Unregistered).merge(
  F: Event::Follow,
  U: Event::Unfollow,
  B: Event::Broadcast,
  P: Event::PrivateMessage,
  S: Event::StatusUpdate,
).freeze

thread1 = Thread.new do

  puts("Listening for events on #{EVENT_PORT}")

  server = TCPServer.open(EVENT_PORT)

  loop do
    Thread.fork(server.accept) do |event_socket|
      event_socket.each_line do |payload|
        message = Message.new(payload)

        seq_no_to_message[message.sequence] = message

        while seq_no_to_message[last_seq_no + 1]
          next_message = seq_no_to_message[last_seq_no + 1]

          event_handler = EVENT_HANDLERS[next_message.kind]

          event = event_handler.new(
            client_pool, follow_registry
          )

          event.process(next_message)

          last_seq_no = next_message.sequence
        end
      end

      event_socket.close
    end
  end
end

thread2 = Thread.new do

  puts("Listening for client requests on #{CLIENT_PORT}")

  server = TCPServer.open(CLIENT_PORT)

  loop do
    Thread.fork(server.accept) do |socket|
      user_id_string = socket.gets
      if user_id_string
        user_id = user_id_string.to_i
        client_pool[user_id] = socket
        puts("User connected: #{user_id} (#{client_pool.size} total)")
      end
    end
  end
end

thread1.join
thread2.join
