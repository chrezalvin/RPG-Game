require_relative "../../Parents/Effect"
require_relative "../Damages/EffectDamage"

class Shielded < Effect
    @damage_reduction_multiplier = 0.75
    @name = "Shielded"
    @description = "Reduces the next damage taken by #{@damage_reduction_multiplier * 100}%"
    def initialize()
        @is_used = false
    end

    def self.damage_reduction_multiplier
        @damage_reduction_multiplier
    end

    def on_before_take_damage(damage)
        super(damage)

        damage.damage = (damage.damage * self.class.damage_reduction_multiplier).to_i
        @is_used = true


        @effect_owner.cleanup_expired_effects
    end

    def is_expired?
        @is_used
    end
end