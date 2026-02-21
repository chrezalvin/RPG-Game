class Mp
  attr_reader :current_mp, :max_mp, :initial_mp, :initial_max_mp

  @@initial_mp = 100
  @@initial_max_mp = 100
  def initialize(current_mp: nil, max_mp: nil)
    @current_mp = current_mp || @@initial_mp
    @max_mp = max_mp || @@initial_max_mp

    @on_mp_used_listeners = []
    @on_mp_added_listeners = []
    @on_mp_changed_listeners = []
  end

  def add_mp(amount)
    if amount.is_a? Integer
      @on_mp_added_listeners.each{
        |listener| listener.call(amount)
      }

      @current_mp = (@current_mp + amount).clamp(0, @max_mp)

      @on_mp_changed_listeners.each{
        |listener| listener.call(@current_mp)
      }
    else
      throw "Error: the amount of mp to add is not an integer"
    end
  end

  def use_mp(amount)
    if amount.is_a? Integer
      @on_mp_used_listeners.each{
        |listener| listener.call(amount)
      }

      @current_mp = @current_mp - amount

      @on_mp_changed_listeners.each{
        |listener| listener.call(@current_mp)
      }
    else
      throw "Error: the amount of mp used is not an integer"
    end
  end

  def add_on_mp_used_listener(listener)
    @on_mp_used_listeners.push(listener)
  end

  def add_on_mp_added_listener(listener)
    @on_mp_added_listeners.push(listener)
  end

  def add_on_mp_changed_listener(listener)
    @on_mp_changed_listeners.push(listener)
  end
end