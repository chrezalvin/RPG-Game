require "utils/Event"
require "Parents/Stats/Dodge"
require "Parents/ActionProfile/Damage"
require "Parents/Actionable/Damageable"

class DamageAvoidable
    attr_reader :on_damage_avoided

    # @param dodge [Dodge] the Dodge instance to be used for damage avoidance
    # @param damageable [Damageable] the creature that can take damage and have its damage avoided
    @@min_accuracy_chance_percentage = 10
    def initialize(dodge, damageable)
        throw "Error: dodge must be an instance of Dodge, got #{dodge.class}" unless dodge.is_a? Dodge

        @dodge = dodge
        @damageable = damageable

        # Events for hooking into the damage avoidance process
        @on_damage_avoided = Event.new()

        @damageable.on_before_take_damage.subscribe do |damage|
            can_avoid(damage)
        end
    end

    # @param damage [Damage] the damage instance to check for avoidance
    def can_avoid(damage)
        if damage.accuracy == nil
            return false
        end

        if (@dodge.dodge + damage.accuracy) == 0
            return false
        end

        chance = (@dodge.dodge / (@dodge.dodge + damage.accuracy) * 100).to_i

        is_avoided = rand(100) < [@@min_accuracy_chance_percentage, chance].max

        if is_avoided
            @on_damage_avoided.emit(damage)
        end

        damage.is_miss = is_avoided
    end
end