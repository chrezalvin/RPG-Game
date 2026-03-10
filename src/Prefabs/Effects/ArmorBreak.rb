require "Parents/Effect"

class ArmorBreak < Effect
    @def_reduction_multiplier_percentage = 50
    @name = "Armor Break"
    @description = "Reduces defense by #{@def_reduction_multiplier_percentage}%"
    def initialize(stack = 1)
        super()
        @stack = stack
    end

    def self.def_reduction_multiplier_percentage
        @def_reduction_multiplier_percentage
    end

    # @param defense [Defense] 
    def modify_defense(defense)
        super(defense)
        defense.defense = (defense.defense * (self.class.def_reduction_multiplier_percentage) / 100).to_i
    end

    # @param creature [Creature] the creature to apply the effect to
    def apply_effect(creature)
        throw "creature must be an instance of Creature, got #{creature.class}" unless creature.is_a? Creature

        effect = creature.find_effect(self.class)

        if effect == nil
            self.apply_effect(creature)
        else
            effect.add_stack(self.stack)
        end
    end

    def is_expired?
        @stack <= 0
    end
end