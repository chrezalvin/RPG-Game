require "Parents/Effect"

require "Damages/EffectDamage"

class Shielded < Effect
    @damage_reduction_multiplier_percentage = 75
    @name = "Shielded"
    @description = "Reduces the next damage taken by #{@damage_reduction_multiplier_percentage}%"
    def initialize(stack = 1)
        super()
        @stack = stack
    end

    def self.damage_reduction_multiplier_percentage
        @damage_reduction_multiplier_percentage
    end

    # @param damage [Damage] the damage instance to be modified
    def on_before_take_damage(damage)
        super(damage)

        damage.damage = (damage.damage * (100 - self.class.damage_reduction_multiplier_percentage) / 100).to_i
        
        @stack -= 1
        
        if self.is_expired?
            @effect_owner.cleanup_expired_effects
        end
    end

    def apply_effect(creature)
        found = creature.find_effect(self.class)

        if found.nil?
            creature.apply_effect(self)
            @effect_owner = creature
        else
            found.add_stack(@stack)
        end
    end

    def is_expired?
        @stack <= 0
    end
end