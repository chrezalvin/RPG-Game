class Hp
  attr_reader :current_hp, :max_hp, :initial_hp, :initial_max_hp

  @@initial_hp = 100
  @@initial_max_hp = 100
  def initialize(current_hp: nil, max_hp: nil)
    @current_hp = current_hp || @@initial_hp
    @max_hp = max_hp || @@initial_max_hp

    @on_take_damage_listeners = []
    @on_heal_listeners = []
    @on_dead_listeners = []
    @on_hp_changed_listeners = []
  end

  def take_damage(damage)
    if damage.is_a? Integer
      @on_take_damage_listeners.each{
          |listener| listener.call(damage)
      }

      @current_hp = @current_hp - damage

      if(current_hp <= 0)
        @current_hp = 0
        @on_dead_listeners.each{
          |listener| listener.call()
        }
      else
        @on_hp_changed_listeners.each{
          |listener| listener.call(@current_hp)
        }
      end
    else
      throw "Error: damage is not an integer"
    end
  end

  def heal(amount)
    if amount.is_a? Integer
      @on_heal_listeners.each{
        |listener| listener.call(amount)
      }

      @current_hp = (@current_hp + amount).clamp(0, @max_hp)

      @on_hp_changed_listeners.each{
        |listener| listener.call(@current_hp)
      }
    else
      throw "Error: heal amount is not an integer"
    end
  end

  def add_on_get_hit_listener(listener)
    @on_take_damage_listeners.push(listener)
  end

  def add_on_heal_listener(listener)
    @on_heal_listeners.push(listener)
  end

  def add_on_dead_listener(listener)
    @on_dead_listeners.push(listener)
  end

  def add_on_hp_changed_listener(listener)
    @on_hp_changed_listeners.push(listener)
  end
end