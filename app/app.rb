require_relative 'initializers/logger'
require_relative 'initializers/dependencies'
require_relative 'initializers/config'
require_relative 'servers/main'

class App
  def start
    Server.run
  end

  def self.log
    @@logger ||= AppLogger.new
    @@logger
  end
end

App.new.start

