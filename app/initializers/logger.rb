require 'logger'

class AppLogger
  def initialize
    @logger = Logger.new(STDOUT)
  end

  def info string, color = :cyan
    @logger.info c color, string
  end

  def warn string, color = :red
    @logger.info c color, string
  end

  private

  def c( color, text = nil )
    "\x1B[" + ( COLOR_ESCAPES[ color ] || 0 ).to_s + 'm' + ( text ? text + "\x1B[0m" : "" )
  end

  def bc( color, text = nil )
    "\x1B[" + ( ( COLOR_ESCAPES[ color ] || 0 ) + 10 ).to_s + 'm' + ( text ?  text + "\x1B[0m" : "" )
  end

  COLOR_ESCAPES = {
    none:    0,
    bright:  1,
    black:   30,
    red:     31,
    green:   32,
    yellow:  33,
    blue:    34,
    magenta: 35,
    cyan:    36,
    white:   37,
    default: 39,
  }.freeze
end
