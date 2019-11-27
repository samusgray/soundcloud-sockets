require 'set'
require 'socket'
require 'yaml'

require_relative 'server'

APP_CONFIG = YAML.load(
  File.open('app/config/app.yml').read
)

Server.run
