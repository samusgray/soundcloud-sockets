require 'set'
require 'socket'
require 'yaml'

APP_CONFIG = YAML.load(
  File.open('app/config/app.yml').read
)

require_relative 'server'
require_relative 'message'

Thread.abort_on_exception = true

Server.run
