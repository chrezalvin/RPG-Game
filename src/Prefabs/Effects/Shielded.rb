require "Parents/Action/Effect"

class Shielded < Effect
    def initialize()
        super(
            name: "Shielded",
            description: "Reduces the next damage taken by 75%, removed after using any skill"
        )

        @damage_reduction_multiplier_percentage = 75
    end

    def short_display_name
        "Sh"
    end

    def on_attach(creature)
        super(creature)

        creature.damageable.on_before_take_damage.subscribe(method(:on_before_take_damage))
        creature.skill_usable.on_before_use_skill.subscribe(method(:on_before_use_skill))
    end

    def on_detach(creature)
        creature.damageable.on_before_take_damage.unsubscribe(method(:on_before_take_damage))
        creature.skill_usable.on_before_use_skill.unsubscribe(method(:on_before_use_skill))
    end

    # @param damage [Damage] the damage instance to be modified
    def on_before_take_damage(damage)
        damage.damage = (damage.damage * (100 - @damage_reduction_multiplier_percentage) / 100).to_i

        @effect_owner.effectable.remove_effect(self)
    end

    def on_before_use_skill(skill, target)
        @effect_owner.effectable.remove_effect(self)
    end
end