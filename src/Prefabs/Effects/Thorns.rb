require_relative "../../Parents/Effect"
require_relative "../Damages/EffectDamage"

class Thorns < Effect
    @damage_fraction_multiplier = 0.25
    @initial_durability = 3
    @name = "Thorns"
    @description = "Deals #{@damage_fraction_multiplier}x damage to the attacker back when the bearer takes damage for #{@initial_durability} times"
    def initialize()
        @durability = self.class.initial_durability
    end

    def self.damage_fraction_multiplier
        @damage_fraction_multiplier
    end
    
    def self.initial_durability
        @initial_durability
    end

    def on_after_take_damage(damage)
        super(damage)
        if damage.damage_dealer != nil
            effectDamage = EffectDamage.new((damage.damage * self.class.damage_fraction_multiplier).to_i)
            damage.damage_dealer.take_damage(effectDamage)
        end

        @effect_owner.cleanup_expired_effects
    end

    def is_expired?
        @durability <= 0
    end
end