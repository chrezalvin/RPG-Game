require "Parents/Damage"
require "Heal/BasicHeal"

class LifeStealDamage < Damage
    def initialize(
        amount: nil,
        damage_dealer: nil,
        damage_type: nil,
        lifesteal_percentage: 0
    )
        super(amount, damage_dealer, false)
        @damage_type = damage_type
        @lifesteal_percentage = lifesteal_percentage
    end

    def apply_to(creature)
        super(creature)

        heal = BasicHeal.new((@damage * @lifesteal_percentage / 100).to_i, @damage_dealer)
        heal.apply_to(@damage_dealer)
    end
end