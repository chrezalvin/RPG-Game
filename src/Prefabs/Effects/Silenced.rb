require "Parents/Action/Effect"

class Silenced < Effect
    attr_reader :stack
    
    def initialize(stack = 1)
        super(
            name: "Silenced",
            description: "Reduces the next MATK by 50%, -1 stack for each turn"
        )

        @stack = stack
        @matk_reduction_multiplier_percentage = 50
    end

    def short_display_name
        "Si(#{@stack})"
    end

    def on_attach(creature)
        super(creature)
        
        creature.matk.matk_modifiers.push(method(:modify_matk))
        creature.turnable.on_before_turn_end.subscribe(method(:on_turn_ends))
    end

    def on_update(silenced)
        throw "effect must be an instance of Silenced, got #{silenced.class}" unless silenced.is_a? Silenced

        @stack += silenced.stack
    end

    def on_detach(creature)
        creature.matk.matk_modifiers.delete(method(:modify_matk))
        creature.turnable.on_before_turn_end.unsubscribe(method(:on_turn_ends))
    end

    def modify_matk(matk)
        (matk.matk_amount * (100 - @matk_reduction_multiplier_percentage) / 100).to_i
    end

    def on_turn_ends
        @stack -= 1

        if @stack <= 0
            @effect_owner.effectable.remove_effect(self)
        end
    end
end