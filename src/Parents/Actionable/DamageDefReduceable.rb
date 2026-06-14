require "utils/Event"
require "Parents/Stats/Defense"
require "Parents/ActionProfile/Damage"
require "Parents/Actionable/Damageable"

class DamageDefReduceable
    attr_reader :on_damage_reduced_by_defense

    # @param defense [Defense] the Defense instance to be reduced by this damage
    # @param damageable [Damageable] the creature that can take damage and have its defense reduced
    def initialize(defense, damageable)
        throw "Error: defense must be an instance of Defense, got #{defense.class}" unless defense.is_a? Defense

        @def = defense
        @damageable = damageable

        # Events for hooking into the damage defense reduction process
        @on_damage_reduced_by_defense = Event.new()

        @damageable.on_before_take_damage.subscribe do |damage|
            self.reduce_damage(damage)
        end
    end

    # @param damage [Damage] the damage instance to be applied to the defense
    def reduce_damage(damage)
        throw "Error: damage must be an instance of Damage, got #{damage.class}" unless damage.is_a? Damage

        before_reduction_damage = damage.damage
        damage.damage = [damage.damage - @def.defense, 0].max

        dif = before_reduction_damage - damage.damage

        @on_damage_reduced_by_defense.emit(dif)
    end
end