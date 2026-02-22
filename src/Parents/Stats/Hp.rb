require_relative "../Damage"
require_relative "../Heal"

class Hp
  attr_reader :current_hp, :max_hp

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
    throw "Error: damage is not a Damage object" unless damage.is_a? Damage

    @on_take_damage_listeners.each{
        |listener| listener.call(damage)
    }

    @current_hp = @current_hp - damage.damage

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
  end

  def heal(heal_instance)
    throw "Error: healInstance is not a Heal object" unless heal_instance.is_a? Heal
    
    @on_heal_listeners.each{
      |listener| listener.call(heal_instance)
    }

    @current_hp = (@current_hp + heal_instance.heal).clamp(0, @max_hp)

    @on_hp_changed_listeners.each{
      |listener| listener.call(@current_hp)
    }
  end

  def is_dead?
    @current_hp <= 0
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

  def current_hp_colorized
    @current_hp.to_s.colorize(:red)
  end

  def max_hp_colorized
    @max_hp.to_s.colorize(:red)
  end
end