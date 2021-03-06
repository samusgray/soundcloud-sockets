require_relative "#{ROOT_DIR}/models/message"
require_relative "#{ROOT_DIR}/models/events/broadcast"
require_relative "#{ROOT_DIR}/models/events/follow"
require_relative "#{ROOT_DIR}/models/events/private_message"
require_relative "#{ROOT_DIR}/models/events/status_update"
require_relative "#{ROOT_DIR}/models/events/unfollow"
require_relative "#{ROOT_DIR}/models/events/unregistered"

class EventDispatcher
  # Routes messages to corresponding event handler. When a message kind
  # does does not have a match in the EVENT_ROUTES then Event::Unregistered
  # is used.
  #
  # Params:
  # +events_queue+::    +[EventQueue]+     instance of EventQueue for queued messages
  # +client_pool+::     +[ClientPool]+     instance of ClientPool to provide event handlers
  # +follow_registry+:: +[FollowRefistry]+ instance of FollowRegistry to provide event handlers

  def initialize events_queue, client_pool, follow_registry
    @events_queue,
    @client_pool,
    @follow_registry = events_queue, client_pool, follow_registry

    # Default message for first iteration
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

  private

  EVENT_HANDLERS = Hash.new(Event::Unregistered).merge(
    F: Event::Follow,
    U: Event::Unfollow,
    B: Event::Broadcast,
    P: Event::PrivateMessage,
    S: Event::StatusUpdate,
  ).freeze
end
