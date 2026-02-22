require_relative "../../Parents/Effect"
require_relative "../Damages/EffectDamage"

class Shielded < Effect
    @damage_increase_multiplier = 0.5
    @name = "Downed"
    @description = "Increases the next damage taken by #{@damage_increase_multiplier * 100}%"
    def initialize()
        super()
        @is_used = false
    end

    def self.damage_increase_multiplier
        @damage_increase_multiplier
    end

    def on_before_take_damage(damage)
        super(damage)

        damage.damage = (damage.damage * (100 + self.class.damage_increase_multiplier) / 100).to_i
        @is_used = true


        @effect_owner.cleanup_expired_effects
    end

    def is_expired?
        @is_used
    end
end