require "Parents/Effect"

class Silenced < Effect
    @matk_reduction_multiplier_percentage = 50
    @name = "Silenced"
    @description = "Reduce the next heal received by #{@matk_reduction_multiplier_percentage}%"
    def initialize(stack = 1)
        super()
        @stack = stack
    end

    def self.matk_reduction_multiplier_percentage
        @matk_reduction_multiplier_percentage
    end

    def modify_matk(matk)
        super(matk)

        matk.matk_amount = (matk.matk_amount * (100 - self.class.matk_reduction_multiplier_percentage) / 100).to_i
    end
  
    def on_before_use_skill(skill, target)
        super(skill, target)

        @stack -= 1
        @effect_owner.cleanup_expired_effects if self.is_expired?
    end

    def apply_effect(creature)
        throw "creature must be an instance of Creature, got #{creature.class}" unless creature.is_a? Creature

        # find if the creature already has this effect
        existing_effect = creature.find_effect(self.class)

        if existing_effect
            # if the creature already has this effect, refresh the effect
            existing_effect.add_stack(@stack)
        else
            # if the creature does not have this effect, apply the effect as normal
            creature.apply_effect(self)
            @effect_owner = creature
        end
    end

    def is_expired?
        @stack <= 0
    end
end