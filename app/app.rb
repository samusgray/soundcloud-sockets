require 'set'
require 'socket'
require 'yaml'
require 'json'

require_relative 'server'

APP_CONFIG = YAML.load(
  File.open('config/app.yml').read
)

Server.run
