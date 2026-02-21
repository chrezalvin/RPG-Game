require_relative "./Creature"

class Damage
    attr_accessor :damage, :damage_type, :is_effect, :damage_dealer
    def initialize(damage_amount, damage_dealer, is_effect = true)
        if (damage_amount.is_a? Integer) && ((damage_dealer.is_a? Creature) || (damage_dealer == nil))
            @damage = damage_amount
            @damage_dealer = damage_dealer
            @damage_type = "unknown"
            @is_effect = is_effect
        else
            throw "invalid type, Damage amount is #{damage_amount.class} and damage_dealer is #{damage_dealer.class}"
        end
    end
end