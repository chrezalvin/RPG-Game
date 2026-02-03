require_relative "../Creatures/Creature"

class Damage
    attr_accessor :damage, :damage_type
    def initialize(damage_amount, damage_dealer)
        if (damage_amount.is_a? Integer) && (damage_dealer.is_a? Creature)
            @damage = damage_amount
            @damage_dealer = damage_dealer
            @damage_type = "unknown"
        else
            throw "invalid type"
        end

    end
end