require "utils/Event"
require "Parents/Stats/Effects"
require "Parents/Action/Effect"

class Effectable
    attr_reader :on_before_effect_applied, 
                :on_after_effect_applied, 
                :on_before_remove_effect, 
                :on_after_remove_effect,
                :on_before_effect_updated,
                :on_after_effect_updated

    # @param effects [Effects] the Effects instance representing the creature's current effects
    # @param creature [Creature] the creature that has the effects
    def initialize(effects, creature)
        throw "Error: effects must be an instance of Effects, got #{effects.class}" unless effects.is_a? Effects
        @effects = effects
        @creature = creature

        @on_before_effect_applied = Event.new()
        @on_after_effect_applied = Event.new()

        @on_before_effect_updated = Event.new()
        @on_after_effect_updated = Event.new()
        
        @on_before_remove_effect = Event.new()
        @on_after_remove_effect = Event.new()
    end

    # @param effect [Effect] the Effect instance to be applied
    def apply_effect(effect)
        throw "Error: effect must be an instance of Effect, got #{effect.class}" unless effect.is_a? Effect

        existing_effect = @effects.find_effect(effect.class)
        if existing_effect
            on_before_effect_updated.emit(existing_effect)

            existing_effect.on_update(effect)

            on_after_effect_updated.emit(existing_effect)
        else
            on_before_effect_applied.emit(effect)

            @effects.effects << effect
            effect.on_attach(@creature)

            on_after_effect_applied.emit(effect)
        end
    end

    # @param effect [Effect] the Effect instance to be removed
    def remove_effect(effect)
        throw "Error: effect must be an instance of Effect, got #{effect.class}" unless effect.is_a? Effect

        @on_before_remove_effect.emit(effect)

        effect.on_detach(@creature)
        @effects.effects.delete(effect)

        @on_after_remove_effect.emit(effect)
    end
end