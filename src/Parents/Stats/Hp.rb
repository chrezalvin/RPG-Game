require "forwardable"
require "utils/Event"

class Hp extend Forwardable
  attr_reader :current_hp, :max_hp, 
      :on_hp_changed, :on_hp_reached_zero

  @@initial_hp = 100
  @@initial_max_hp = 100

  # @param current_hp [Integer]
  # @param max_hp [Integer]
  def initialize(current_hp: nil, max_hp: nil)
    @current_hp = current_hp || @@initial_hp
    @max_hp = max_hp || @@initial_max_hp
    
    @on_hp_changed = Event.new()
    @on_hp_reached_zero = Event.new()
  end

  protected def modify_hp(value)
    @current_hp += value
    @current_hp = @current_hp.clamp(0, @max_hp)

    @on_hp_changed.emit(@current_hp)

    if @current_hp <= 0
      @on_hp_reached_zero.emit()
    end
  end

  # @param value [Integer] the amount of hp to be subtracted
  def -(value)
    modify_hp(-value)
  end

  # @param value [Integer] the amount of hp to be added
  def +(value)
    modify_hp(value)
  end

  def hp_colorized
    return "#{@current_hp.to_s.colorize(:red)}/#{@max_hp.to_s.colorize(:red)}"
  end

  # @return [String] the current hp in colorized format
  def current_hp_colorized
    @current_hp.to_s.colorize(:red)
  end

  # @return [String] the max hp in colorized format
  def max_hp_colorized
    @max_hp.to_s.colorize(:red)
  end
end