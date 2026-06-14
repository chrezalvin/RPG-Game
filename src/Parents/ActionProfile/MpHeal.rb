require "Parents/Stats/Mp"

class MpHeal
    attr_accessor :heal_type, :is_effect, :healer

    # @param heal_amount [Integer] the amount of healing
    # @param healer [Creature, nil] the creature that heals
    def initialize(heal_amount, is_effect = true)
        throw "Error: heal_amount must be an Integer, got #{heal_amount.class}" unless heal_amount.is_a? Integer

        @heal = heal_amount

        @heal_type = "unknown"
        @is_effect = is_effect
    end

    # @return [Integer] the amount of healing
    def mp_heal
        heal = @heal

        return heal.to_i
    end

    def mp_heal_colorized
        self.mp_heal.to_s.colorize(:light_blue)
    end
end