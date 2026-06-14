require "colorize"
require "Parents/Creature"
require "Parents/Stats/Hp"

class Heal
    attr_accessor :heal_type, :is_effect, :healer

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

    # @return [Integer] the amount of healing
    def heal
        heal = @heal

        return heal.to_i
    end

    def heal_colorized
        @heal.to_s.colorize(:green)
    end
end