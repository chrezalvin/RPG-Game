require "Parents/Effect"

require "Damages/EffectDamage"

class Shielded < Effect
    @damage_reduction_multiplier = 0.5
    @name = "Shielded"
    @description = "Reduces the next damage taken by #{@damage_reduction_multiplier * 100}%"
    def initialize(stack = 1)
        super()
        @stack = stack
    end

    def self.damage_reduction_multiplier
        @damage_reduction_multiplier
    end

    def on_before_take_damage(damage)
        super(damage)

        damage.damage = (damage.damage * self.class.damage_reduction_multiplier).to_i

        @stack -= 1

        if self.is_expired?
            @effect_owner.cleanup_expired_effects
        end
    end

    def is_expired?
        @stack <= 0
    end
end