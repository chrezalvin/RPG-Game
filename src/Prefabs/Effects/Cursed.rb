require "Parents/Effect"

class Cursed < Effect
    @heal_reduction_multiplier = 0.5
    @name = "Cursed"
    @description = "Reduce the next heal received by #{@heal_reduction_multiplier * 100}%"
    def initialize(stack = 1)
        super()
        @stack = stack
    end

    def self.heal_reduction_multiplier
        @heal_reduction_multiplier
    end

    def on_before_heal(heal_instance)
        super(heal_instance)

        heal_instance.heal = (heal_instance.heal * (100 - self.class.heal_reduction_multiplier) / 100).to_i

        @stack -= 1

        if self.is_expired?
            @effect_owner.cleanup_expired_effects
        end
    end

    def apply_effect(creature)
        throw "creature must be an instance of Creature, got #{creature.class}" unless creature.is_a? Creature

        # find if the creature already has this effect
        existing_effect = creature.effects.find{|effect| effect.class == self.class}

        if existing_effect
            # if the creature already has this effect, refresh the effect
            existing_effect.stack = existing_effect.stack + self.stack
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