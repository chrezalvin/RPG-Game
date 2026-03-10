require "colorize"
require "Parents/Creature"

class Damage
    attr_accessor :damage, :damage_type, :is_effect, :damage_dealer, :has_effects

    # @param damage_amount [Integer] the amount of damage
    # @param damage_dealer [Creature, nil] the creature that deals the damage
    # @param is_effect [Boolean] whether the damage is caused by an effect
    def initialize(damage_amount, damage_dealer, is_effect = true)
        throw "Error: damage_amount must be an Integer, got #{damage_amount.class}" unless damage_amount.is_a? Integer
        throw "Error: damage_dealer must be a Creature or nil, got #{damage_dealer.class}" unless damage_dealer.is_a?(Creature) || damage_dealer == nil

        @damage = damage_amount
        @damage_dealer = damage_dealer
        @damage_type = "unknown"
        @is_effect = is_effect

        # @type [Array<Effect>] the effects that cause this damage, if applicable
        @has_effects = []
    end

    # @param creature [Creature] the creature to apply the damage to
    def apply_to(creature)
        throw "Error: creature is not a Creature object" unless creature.is_a? Creature

        creature.take_damage(self)
    end

    def accuracy
        @damage_dealer&.accuracy.accuracy || 0
    end

    # @return [String] the colorized string representation of the damage amount
    def amount_colorized
        @damage.to_s.colorize(:red)
    end
end