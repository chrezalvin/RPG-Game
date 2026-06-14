require "Parents/Action/Effect"
require "Heal/RegenerationHeal"

class TransformBatBuff < Effect
    def initialize()
        super(
            name: "Transform (Bat)",
            description: "You're a Bat!"
        )

        @effect_owner = nil
        @def_reduction_multiplier_percentage = 50
        @atk_reduction_multiplier_percentage = 50
        @matk_increase_multiplier_percentage = 100
        @dodge_increase_multiplier_percentage = 100
        @speed_increase_multiplier_percentage = 100
        @damage_increase_multiplier_percentage = 100
        @heal_based_damage_multiplier_percentage = 50

    end

    def short_display_name
        "T(B)"
    end

    def on_attach(creature)
        super(creature)
        
        creature.defense.defense_modifiers.push(method(:modify_defense))
        creature.atk.atk_modifiers.push(method(:modify_atk))
        creature.matk.matk_modifiers.push(method(:modify_matk))
        creature.dodge.dodge_modifiers.push(method(:modify_dodge))
        creature.speed.speed_modifiers.push(method(:modify_speed))
        creature.damageable.on_before_take_damage.subscribe(method(:on_before_take_damage))

        @effect_owner = creature
    end

    def on_update(transform_bat_buff)
        throw "effect must be an instance of TransformBatBuff, got #{transform_bat_buff.class}" unless transform_bat_buff.is_a? TransformBatBuff

        @effect_owner.effectable.remove_effect(self)
    end

    def on_detach(creature)
        creature.defense.defense_modifiers.delete(method(:modify_defense))
        creature.atk.atk_modifiers.delete(method(:modify_atk))
        creature.matk.matk_modifiers.delete(method(:modify_matk))
        creature.dodge.dodge_modifiers.delete(method(:modify_dodge))
        creature.speed.speed_modifiers.delete(method(:modify_speed))
        creature.damageable.on_before_take_damage.unsubscribe(method(:on_before_take_damage))
    end

    # @param defense [Defense] 
    def modify_defense(defense)
        (defense.defense * (@def_reduction_multiplier_percentage) / 100).to_i
    end

    # @param atk [Atk]
    def modify_atk(atk)
        (atk.atk_amount * (100 - @atk_reduction_multiplier_percentage) / 100).to_i
    end

    # @param matk [Matk]
    def modify_matk(matk)
        (matk.matk_amount * (100 + @matk_increase_multiplier_percentage) / 100).to_i
    end

    def modify_dodge(dodge)
        (dodge.dodge * (100 + @dodge_increase_multiplier_percentage) / 100).to_i
    end

    def modify_speed(speed)
        (speed.speed * (100 + @speed_increase_multiplier_percentage) / 100).to_i
    end

    # @param damage [Damage] the damage instance to be modified
    def on_before_take_damage(damage)
        (damage.damage * (100 + @damage_increase_multiplier_percentage) / 100).to_i
    end
end