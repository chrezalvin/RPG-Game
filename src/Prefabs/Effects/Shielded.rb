require "Parents/Effect"

class Cursed < Effect
    @matk_reduction_multiplier_percentage = 50
    @name = "Cursed"
    @description = "Reduce the next heal received by #{@matk_reduction_multiplier_percentage}%"
    def initialize(stack = 1)
        super()
        @stack = stack
    end

    def self.matk_reduction_multiplier_percentage
        @matk_reduction_multiplier_percentage
    end

    def on_before_heal(heal_instance)
        super(heal_instance)

        heal_instance.heal = (heal_instance.heal * (100 - self.class.matk_reduction_multiplier_percentage) / 100).to_i

        @stack -= 1

        if self.is_expired?
            @effect_owner.cleanup_expired_effects
        end
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