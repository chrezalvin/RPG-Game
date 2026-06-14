require "Parents/Stats/Hp"
require "Parents/ActionProfile/Damage"

class Damageable
    attr_reader :on_before_take_damage, :on_after_take_damage, :on_damage_miss

    # @param hp [Hp] the HP instance representing the creature's health
    def initialize(hp)
        throw "Error: hp must be an instance of Hp, got #{hp.class}" unless hp.is_a? Hp
        @hp = hp

        @on_before_take_damage = Event.new()
        @on_after_take_damage = Event.new()
        @on_damage_miss = Event.new()
    end

    # @param damage_instance [Damage] the damage instance representing the damage to be taken
    def take_damage(damage_instance)
        throw "Error: damage_instance must be an instance of Damage, got #{damage_instance.class}" unless damage_instance.is_a? Damage
        
        @on_before_take_damage.emit(damage_instance)

        if damage_instance.is_miss
            @on_damage_miss.emit(damage_instance)
            return
        end

        @hp - damage_instance.damage

        @on_after_take_damage.emit(damage_instance)
    end
end