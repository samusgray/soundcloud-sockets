require 'set'
require 'socket'
require 'yaml'

APP_CONFIG = YAML.load(
  File.open('config/app.yml').read
)

require_relative 'server'
require_relative 'message'
require_relative 'events/broadcast'
require_relative 'events/follow'
require_relative 'events/private_message'
require_relative 'events/status_update'
require_relative 'events/unfollow'
require_relative 'events/unregistered'

Thread.abort_on_exception = true

EVENT_HANDLERS = Hash.new(Event::Unregistered).merge(
  F: Event::Follow,
  U: Event::Unfollow,
  B: Event::Broadcast,
  P: Event::PrivateMessage,
  S: Event::StatusUpdate,
).freeze

Server.run
