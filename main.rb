require 'set'

require 'socket'
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

class Message
  def initialize payload
    payload_parts = payload.split('|')

    @raw      = payload_parts
    @sequence = payload_parts[0]
    @type     = payload_parts[1]
    @actor    = payload_parts[2]
    @target   = payload_parts[3]
  end

  attr_reader :raw

  def sequence
    @sequence.to_i
  end

  def type
    @type.to_sym
  end

  def actor
    @actor.to_i if @actor
  end

  def target
    @target.to_i if @target
  end
end

thread1 = Thread.new do

  puts("Listening for events on #{EVENT_PORT}")

  server = TCPServer.open(EVENT_PORT)

  loop do
    Thread.fork(server.accept) do |event_socket|
      event_socket.each_line do |payload|
        message = Message.new(payload)

        seq_no_to_message[message.sequence] = message.raw

        while seq_no_to_message[last_seq_no + 1]
          next_message = seq_no_to_message[last_seq_no + 1]
          next_payload = next_message.join('|')

          seq_no = next_message[0].to_i
          kind = next_message[1].strip

          event_handler  = EVENT_HANDLERS[kind.to_sym]
          event = event_handler.new()

          case event.kind
          when 'F'
            from_user_id = next_message[2].to_i
            to_user_id = next_message[3].to_i

            followers = follow_registry[to_user_id] || Set.new
            followers << from_user_id
            follow_registry[to_user_id] = followers

            socket = client_pool[to_user_id]
            if socket
              socket.puts(next_payload)
              socket.flush
            end

          when 'U'
            from_user_id = next_message[2].to_i
            to_user_id = next_message[3].to_i

            followers = follow_registry[to_user_id] || Set.new
            followers.delete(from_user_id)
            follow_registry[to_user_id] = followers

          when 'P'
            to_user_id = next_message[3].to_i

            socket = client_pool[to_user_id]
            if socket
              socket.puts(next_payload)
              socket.flush
            end

          when 'B'
            puts "kind B:"
            puts next_payload
            client_pool.values.each do |socket|
              # socket.puts(next_payload)
              socket.flush
            end

          when 'S'
            from_user_id = next_message[2].to_i

            followers = follow_registry[from_user_id] || Set.new
            followers.each do |follower|
              socket = client_pool[follower]

              if socket
                socket.puts(next_payload)
                socket.flush
              end
            end
          end

          last_seq_no = seq_no
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
