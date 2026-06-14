require "Parents/Action/Effect"

class Quick < Effect
    attr_reader :stack
    attr_accessor :speed_increase_multiplier, :dodge_increase_multiplier, :nmpr_reduction_multiplier
    def initialize(stack = 1)
        super(
            name: "Quick",
            description: "Doubles your speed and dodge but halves your natural mp regen, one stack is reduced after each turn, can be stacked",
        )
        @stack = stack

        @speed_increase_multiplier_percentage = 200
        @dodge_increase_multiplier_percentage = 200
        @nmpr_reduction_multiplier_percentage = 50
    end

    def display_name
        "#{self.name} (#{@stack})"
    end

    def short_display_name
        "Qu(#{@stack})"
    end

    def on_attach(creature)
        super(creature)

        creature.speed.base_speed_modifiers.push(method(:modify_speed))
        creature.dodge.base_dodge_modifiers.push(method(:modify_dodge))
        creature.nmpr.base_natural_mp_regen_modifiers.push(method(:modify_natural_mp_regen))
        creature.turnable.on_before_turn_end.subscribe(method(:on_turn_ends))
    end

    # @param quick [Quick] the new Quick effect to be merged with this effect
    def on_update(quick)
        throw "effect must be an instance of Quick, got #{quick.class}" unless quick.is_a? Quick

        @stack += quick.stack
    end

    def on_detach(creature)
        creature.speed.base_speed_modifiers.delete(method(:modify_speed))
        creature.dodge.base_dodge_modifiers.delete(method(:modify_dodge))
        creature.nmpr.base_natural_mp_regen_modifiers.delete(method(:modify_natural_mp_regen))
        creature.turnable.on_before_turn_end.unsubscribe(method(:on_turn_ends))
    end

    def on_turn_ends
        @stack -= 1

        if self.is_expired?
            @effect_owner.effectable.remove_effect(self)
        end
    end

    # @param speed [Integer] the speed to modify
    def modify_speed(speed)
        return (speed * (@speed_increase_multiplier_percentage / 100.0)).to_i
    end

    # @param dodge [Integer] the dodge to modify
    def modify_dodge(dodge)
        return (dodge * (@dodge_increase_multiplier_percentage / 100.0)).to_i
    end

    # @param speed [Integer] the natural mp regen to modify
    def modify_natural_mp_regen(nmpr)
        return (nmpr * (@nmpr_reduction_multiplier_percentage / 100.0)).to_i
    end

    def is_expired?
        @stack <= 0
    end
end