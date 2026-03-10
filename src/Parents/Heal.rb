require "colorize"
require "Parents/Creature"

class Heal
    attr_accessor :heal, :heal_type, :is_effect, :healer

    # @param heal_amount [Integer] the amount of healing
    # @param healer [Creature, nil] the creature that heals
    def initialize(heal_amount, healer, is_effect = true)
        throw "Error: heal_amount must be an Integer, got #{heal_amount.class}" unless heal_amount.is_a? Integer
        throw "Error: healer must be a Creature or nil, got #{healer.class}" unless (healer.is_a? Creature) || healer.nil?

        @heal = heal_amount
        @healer = healer

        @heal_type = "unknown"
        @is_effect = is_effect
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