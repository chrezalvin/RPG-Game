require "Parents/Action/Effect"

require "Damages/EffectDamage"

class Thorns < Effect
    def initialize()
        super(
            name: "Thorns",
            description: "Deals 25% damage to the attacker back when the bearer takes damage"
        )

        @durability = 3
        @damage_fraction_multiplier_percentage = 25
    end

    def short_display_name
        "Th(#{@durability})"
    end

    def on_attach(creature)
        super(creature)

        creature.damageable.on_after_take_damage.subscribe(method(:on_after_take_damage))
    end

    def on_detach(creature)
        creature.damageable.on_after_take_damage.unsubscribe(method(:on_after_take_damage))
    end

    def on_after_take_damage(damage)
        if damage.damage_dealer == nil
            return
        end

        effectDamage = EffectDamage.new((damage.damage * @damage_fraction_multiplier_percentage / 100).to_i, @effect_owner)
        damage.damage_dealer.take_damage(effectDamage)

        @durability -= 1

        if @durability <= 0
            @effect_owner.effectable.remove_effect(self)
        end
    end
end