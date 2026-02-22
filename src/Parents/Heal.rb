require "colorize"
require_relative "./Creature"

class Heal
    attr_accessor :heal, :heal_type, :is_effect, :healer
    def initialize(heal_amount, healer, is_effect = true)
        if (heal_amount.is_a? Integer) && ((healer.is_a? Creature) || (healer == nil))
            @heal = heal_amount
            @healer = healer

            @heal_type = "unknown"
            @is_effect = is_effect
        else
            throw "invalid type, Damage amount is #{damage_amount.class} and damage_dealer is #{damage_dealer.class}"
        end
    end

    def apply_to(creature)
        throw "Error: creature is not a Creature object" unless creature.is_a? Creature

        creature.heal(self)
    end

    def amount
        @heal
    end

    def amount_colorized
        @heal.to_s.colorize(:green)
    end
end