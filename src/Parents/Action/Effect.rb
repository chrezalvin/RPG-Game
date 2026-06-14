require "Parents/Creature"


class Effect
    attr_accessor :name, :description

    # @param name [String] the name of the effect
    # @param description [String] the description of the effect
    def initialize(
        name: "unknown effect",
        description: "unknown description"
    )
        @name = name
        @description = description

        #@type [Creature, nil]
        @effect_owner = nil
    end

    def display_name
        self.name
    end

    def short_display_name
        "???"
    end
    
    # @param creature [Creature] the creature to attach the effect to
    def on_attach(creature)
        throw "creature must be an instance of Creature, got #{creature.class}" unless creature.is_a? Creature

        @effect_owner = creature
    end

    # @param effect [Effect] the effect to be merged with this effect, guaranteed the same class as this effect
    def on_update(effect)
        throw "Error: effect must be an instance of #{self.class}, got #{effect.class}" unless effect.is_a? self.class
    end
    
    # @param creature [Creature] the creature to detach the effect from
    def on_detach(creature)
        throw "creature must be an instance of Creature, got #{creature.class}" unless creature.is_a? Creature
    end
end