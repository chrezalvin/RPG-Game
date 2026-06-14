require "Parents/Action/Effect"

class Cursed < Effect
    attr_reader :stack

    def initialize(stack = 1)
        super(
            name: "Cursed",
            description: "Reduce the next heal received by 50%, removed after receiving a heal, can be stacked"
        )

        @stack = stack
        @heal_reduction_multiplier_percentage = 50
    end

    def name
        "Cursed"
    end

    def display_name
        "#{self.name} (#{@stack})"
    end

    def short_display_name
        "Cu(#{@stack})"
    end

    def on_attach(creature)
        super(creature)

        creature.healable.on_before_heal.subscribe(method(:on_before_heal))
    end

    def on_update(cursed)
        @stack += cursed.stack
    end

    def on_detach(creature)
        creature.healable.on_before_heal.unsubscribe(method(:on_before_heal))
    end

    def on_before_heal(heal_instance)
        heal_instance.heal = (heal_instance.heal * (100 - @heal_reduction_multiplier_percentage) / 100).to_i

        @stack -= 1

        if @stack <= 0
            @effect_owner.effectable.remove_effect(self)
        end
    end
end