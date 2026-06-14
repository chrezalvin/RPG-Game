require "colorize"
require "Parents/Creature"
require "Parents/Stats/Hp"

class Damage
    attr_accessor :damage, 
                :damage_type, 
                :is_effect, 
                :damage_dealer, 
                :has_effects, 
                :is_miss, 
                :piercing

    # @param damage_amount [Integer] the amount of damage
    # @param damage_dealer [Creature] the creature that deals the damage
    def initialize(damage_amount, damage_dealer)
        throw "Error: damage_amount must be an Integer, got #{damage_amount.class}" unless damage_amount.is_a? Integer
        throw "Error: damage_dealer must be a Creature or nil, got #{damage_dealer.class}" unless damage_dealer.is_a?(Creature) || damage_dealer == nil

        @damage = damage_amount
        @damage_dealer = damage_dealer

        # @type [String] the type of damage
        @damage_type = "unknown"
        # @type [Boolean] whether this damage is caused by an effect or not.
        @is_effect = is_effect
        # @type [Boolean] whether this damage is a miss or not
        @is_miss = false
        # @type [Integer] the piercing percentage value of this damage
        @piercing = 0

        # @type [Array<Effect>] the effects that cause this damage, if applicable
        @has_effects = []
    end

    # @return [Integer] the amount of damage
    def damage
        damage = @damage

        return damage.to_i
    end

    def accuracy
        @damage_dealer.acc.accuracy
    end

    # @return [String] the colorized string representation of the damage amount
    def amount_colorized
        @damage.to_s.colorize(:red)
    end
end