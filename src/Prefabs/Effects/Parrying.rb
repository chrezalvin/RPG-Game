require "Parents/Effect"

require "Damages/EffectDamage"

class Parrying < Effect
    @damage_reduction_multiplier_percentage = 50
    @name = "Parrying"
    @description = "Reduces the next damage taken by #{@damage_reduction_multiplier_percentage}% then attacks back using basic attack"
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

        @effect_owner.use_skill(0, damage.damage_dealer)
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