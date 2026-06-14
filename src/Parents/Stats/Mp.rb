require "forwardable"

require "utils/Event"

class Mp extend Forwardable
  attr_reader :current_mp, :max_mp, :on_mp_changed

  @@initial_mp = 100
  @@initial_max_mp = 100

  # @param current_mp [Integer]
  # @param max_mp [Integer]
  def initialize(current_mp: nil, max_mp: nil)
    @current_mp = current_mp || @@initial_mp
    @max_mp = max_mp || @@initial_max_mp

    @on_mp_changed = Event.new()
  end

  protected def modify_mp(value)
    @current_mp += value
    @current_mp = @current_mp.clamp(0, @max_mp)

    @on_mp_changed.emit(@current_mp)
  end

  # @param value [Integer] the amount of mp to be subtracted
  def -(value)
    modify_mp(-value)
  end

  # @param value [Integer] the amount of mp to be added
  def +(value)
    modify_mp(value)
  end

  def mp_colorized
    return "#{@current_mp.to_s.colorize(:cyan)}/#{@max_mp.to_s.colorize(:cyan)}"
  end

  # @return [String] the current mp in colorized format
  def current_mp_colorized
    @current_mp.to_s.colorize(:blue)
  end

  # @return [String] the max mp in colorized format
  def max_mp_colorized
    @max_mp.to_s.colorize(:blue)
  end
end