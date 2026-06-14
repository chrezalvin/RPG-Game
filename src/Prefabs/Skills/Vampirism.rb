require "Parents/Action/Skill"
require "Damages/SkillDamage"
require "Damages/LifeStealDamage"
require "Heal/BasicHeal"

class Vampirism < Skill
    attr_accessor :skill_mp_usage, :skill_heal_multiplier_percentage

    def initialize(skill_owner)
        super(
            skill_owner: skill_owner,
            name: "Vampirism",
            description: "Deals damage to the enemy based on your attack and heal yourself for percentage of the damage dealt",
        )

        @skill_mp_usage = 30
        @skill_heal_multiplier_percentage = 50
    end

    def calculate_damage
        @skill_owner.atk.atk
    end

    def use_skill(creature)
        if !super(creature)
            return
        end

        use_turn = UseTurn.new(@action_time)
        use_mp = MpUse.new(@skill_mp_usage)

        @skill_owner.turnable.reduce_turn_amount(use_turn)
        @skill_owner.mp_usable.use_mp(use_mp)

        lifestealDamage = LifeStealDamage.new(
            amount: self.calculate_damage,
            damage_dealer: @skill_owner,
            damage_type: "skill",
            lifesteal_percentage: @skill_heal_multiplier_percentage
        )

        creature.damageable.take_damage(lifestealDamage)
    end

    def name_display
        self.skill_display_helper(
            skill_name: @name,
            action_time: @action_time,
            skill_mp_usage: @skill_mp_usage,
            can_use_skill: can_use_skill?(@skill_owner),
        )
    end

    def can_use_skill?(creature)
        @skill_owner.mp.current_mp >= @skill_mp_usage && @action_time <= @skill_owner.turns.current_turn
    end
end