require "forwardable"

require "Parents/Damage"
require "Parents/Heal"

require "utils/Event"

class Hp extend Forwardable
  attr_reader :current_hp, :max_hp, 
    :on_take_damage, :on_heal, :on_dead, :on_hp_changed,
    :remove_on_take_damage, :remove_on_heal, :remove_on_dead, :remove_on_hp_changed

  def_delegator :@on_take_damage_listeners, :subscribe, :on_take_damage
  def_delegator :@on_heal_listeners, :subscribe, :on_heal
  def_delegator :@on_dead_listeners, :subscribe, :on_dead
  def_delegator :@on_hp_changed_listeners, :subscribe, :on_hp_changed

  def_delegator :@on_take_damage_listeners, :unsubscribe, :remove_on_take_damage
  def_delegator :@on_heal_listeners, :unsubscribe, :remove_on_heal
  def_delegator :@on_dead_listeners, :unsubscribe, :remove_on_dead
  def_delegator :@on_hp_changed_listeners, :unsubscribe, :remove_on_hp_changed

  @@initial_hp = 100
  @@initial_max_hp = 100

  # @param current_hp [Integer]
  # @param max_hp [Integer]
  def initialize(current_hp: nil, max_hp: nil)
    @current_hp = current_hp || @@initial_hp
    @max_hp = max_hp || @@initial_max_hp

    @on_take_damage_listeners = Event.new()
    @on_heal_listeners = Event.new()
    @on_dead_listeners = Event.new()
    @on_hp_changed_listeners = Event.new()
  end

  # @param damage [Damage]
  # @return [void]
  def take_damage(damage)
    throw "Error: damage is not a Damage object" unless damage.is_a? Damage

    @on_take_damage_listeners.emit(damage)

    @current_hp = @current_hp - damage.damage

    if(current_hp <= 0)
      @current_hp = 0
      @on_dead_listeners.emit()
    else
      @on_hp_changed_listeners.emit(@current_hp)
    end
  end

  # @param heal_instance [Heal]
  # @return [void]
  def heal(heal_instance)
    throw "Error: healInstance is not a Heal object" unless heal_instance.is_a? Heal
    
    @on_heal_listeners.emit(heal_instance)

    @current_hp = (@current_hp + heal_instance.heal).clamp(0, @max_hp)

    @on_hp_changed_listeners.emit(@current_hp)
  end

  # @return [Boolean] true if the creature is dead, false otherwise
  def is_dead?
    @current_hp <= 0
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