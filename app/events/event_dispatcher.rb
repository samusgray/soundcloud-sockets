require_relative '../message'
require_relative 'broadcast'
require_relative 'follow'
require_relative 'private_message'
require_relative 'status_update'
require_relative 'unfollow'
require_relative 'unregistered'

class EventDispatcher
  EVENT_HANDLERS = Hash.new(Event::Unregistered).merge(
    F: Event::Follow,
    U: Event::Unfollow,
    B: Event::Broadcast,
    P: Event::PrivateMessage,
    S: Event::StatusUpdate,
  ).freeze

  def initialize events_queue, client_pool, follow_registry
    @events_queue    = events_queue
    @client_pool     = client_pool
    @follow_registry = follow_registry
    @guard_message   = Message.new '0|Guard'
  end

  def run
    while next_message = @events_queue.next_event(@guard_message)
      event_handler = EVENT_HANDLERS[next_message.kind]
      event         = event_handler.new @client_pool, @follow_registry

      event.process next_message

      @guard_message = next_message
      @events_queue.remove next_message
    end
  end
end
