require "Parents/Action/Effect"

require "Damages/EffectDamage"

class Parrying < Effect
    attr_accessor :damage_reduction_multiplier_percentage, 
        :attack_multiplier_percentage    

    def initialize()
        super(
            name: "Parrying",
            description: "Reduces next damage taken by half then attacks back, removed after parrying or after you use any skill"
        )

        @damage_reduction_multiplier_percentage = 50
        @attack_multiplier_percentage = 100
    end

    def short_display_name
        "Pa"
    end

    def calculate_damage
        (@effect_owner.atk.atk * @attack_multiplier_percentage / 100).to_i
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

        parry_damage = EffectDamage.new(self.calculate_damage)
        damage.damage_dealer.damageable.take_damage(parry_damage)

        @effect_owner.effectable.remove_effect(self)
    end

    def on_before_use_skill(skill, target)
        @effect_owner.effectable.remove_effect(self)
    end
end