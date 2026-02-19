require_relative "./Creature"

class Damage
    attr_accessor :damage, :damage_type
    def initialize(damage_amount, damage_dealer)
        if (damage_amount.is_a? Integer) && (damage_dealer.is_a? Creature)
            @damage = damage_amount
            @damage_dealer = damage_dealer
            @damage_type = "unknown"
        else
            throw "invalid type, Damage amount is #{damage_amount.class} and damage_dealer is #{damage_dealer.class}"
        end
    end
end