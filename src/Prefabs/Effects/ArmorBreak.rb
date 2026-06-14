require "Parents/Action/Effect"

class ArmorBreak < Effect
    attr_accessor :def_reduction_multiplier_percentage

    def initialize()
        super(
            name: "Armor Break",
            description: "Reduces next attack's damage by 50%, removed after turn ends",
        )

        @def_reduction_multiplier_percentage = 50
    end

    def display_name
        @name
    end

    def short_display_name
        "AB"
    end

    def on_attach(creature)
        super(creature)

        creature.defense.defense_modifiers << method(:modify_defense)
        creature.turnable.on_before_turn_end.subscribe(method(:on_turn_ends))
    end

    def on_detach(creature)
        creature.defense.defense_modifiers.delete(method(:modify_defense))
        creature.turnable.on_before_turn_end.unsubscribe(method(:on_turn_ends))
    end

    # @param defense_amount [Integer] the defense amount to be modified
    def modify_defense(defense_amount)
        return (defense_amount * (100 - @def_reduction_multiplier_percentage) / 100).to_i
    end

    def on_turn_ends
        @effect_owner.effectable.remove_effect(self)
    end
end