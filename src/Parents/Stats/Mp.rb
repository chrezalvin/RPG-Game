require "utils/Event"

class Mp
  attr_reader :current_mp, :max_mp

  @@initial_mp = 100
  @@initial_max_mp = 100
  def initialize(current_mp: nil, max_mp: nil)
    @current_mp = current_mp || @@initial_mp
    @max_mp = max_mp || @@initial_max_mp

    @on_mp_used_listeners = Event.new()
    @on_mp_added_listeners = Event.new()
    @on_mp_changed_listeners = Event.new()
  end

  def add_mp(amount)
    throw "Error: the amount of mp to add is not an integer" unless amount.is_a? Integer

    @on_mp_added_listeners.emit(amount)

    @current_mp = (@current_mp + amount).clamp(0, @max_mp)

    @on_mp_changed_listeners.emit(@current_mp)
  end

  def use_mp(amount)
    throw "Error: the amount of mp used is not an integer" unless amount.is_a? Integer

    @on_mp_used_listeners.emit(amount)

    @current_mp = @current_mp - amount

    @on_mp_changed_listeners.emit(@current_mp)
  end

  def add_on_mp_used_listener(listener)
    @on_mp_used_listeners.subscribe(listener)
  end

  def add_on_mp_added_listener(listener)
    @on_mp_added_listeners.subscribe(listener)
  end

  def add_on_mp_changed_listener(listener)
    @on_mp_changed_listeners.subscribe(listener)
  end

  def current_mp_colorized
    @current_mp.to_s.colorize(:blue)
  end

  def max_mp_colorized
    @max_mp.to_s.colorize(:blue)
  end
end