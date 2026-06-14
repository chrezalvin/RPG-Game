require "Parents/Action/Effect"

class Downed < Effect
    def initialize()
        super(
            name: "Downed",
            description: "Increases damage taken by 50%, removed next turn"
        )

        @damage_increase_multiplier_percentage = 50 
    end

    def short_display_name
        "Dn"
    end

    def on_attach(creature)
        super(creature)

        creature.damageable.on_before_take_damage.subscribe(method(:on_before_take_damage))
        creature.turnable.on_before_turn_end.subscribe(method(:on_turn_ends))
    end

    def on_detach(creature)
        creature.damageable.on_before_take_damage.unsubscribe(method(:on_before_take_damage))
        creature.turnable.on_before_turn_end.unsubscribe(method(:on_turn_ends))
    end

    def on_before_take_damage(damage)
        super(damage)

        damage.damage = (damage.damage * (100 + @damage_increase_multiplier_percentage) / 100).to_i

        @effect_owner.effectable.remove_effect(self)
    end

    def on_turn_ends
        @effect_owner.effectable.remove_effect(self)
    end
end