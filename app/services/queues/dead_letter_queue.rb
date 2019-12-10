class DLQ
  # Storage for messages sent to unreachable clients
  #
  # Implemented as a hash table of failed message stored in the appropriate
  # category and order by sequence number.
  #
  # For example:
  #
  # {
  #   bad_message_format:   <SortedSet { [Message @kind='F', sequence=1], [Message @kind='B', sequence=2] >,
  #   unregistered_event:   <SortedSet { [Message @kind='S', sequence=5], [Message @kind='U', sequence=6] >,
  #   client_not_reachable: <SortedSet { [Message @kind='B', sequence=3], [Message @kind='S', sequence=4] >,
  # }
  def initialize
    @queue = Hash[
      QUEUE_CATEGORIES.collect { |category| [category, SortedSet.new] }
    ]
  end

  def report
    queue_report = {}
    @queue.keys.map do |key|
      queue_report[key] = @queue[key].size
    end
    queue_report
  end

  def add message, category
    return if !QUEUE_CATEGORIES.include?(category)
    @queue[category] << message
  end

  private

  QUEUE_CATEGORIES = [
    :bad_message_format,
    :unregistered_event,
    :client_not_reachable,
  ].freeze
end
