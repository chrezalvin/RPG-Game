require "Parents/Action/Skill"
require "Damages/SkillDamage"
require "Effects/Silenced"

class Sonar < Skill
    attr_accessor :skill_mp_usage, :damage_multiplier_percentage

    def initialize(skill_owner)
        super(
            skill_owner: skill_owner,
            name: "Sonar",
            description: "[Requires bat form] Attack the enemy with sound waves, deals magic damage based on your matk, apply silence",
        )

        @skill_mp_usage = 20
        @damage_multiplier_percentage = 60
    end

    def calculate_damage
        (@damage_multiplier_percentage * @skill_owner.matk.matk_amount / 100).to_i
    end

    def use_skill(creature)
        if !super(creature)
            return
        end

        use_turn = UseTurn.new(@action_time)
        use_mp = MpUse.new(@skill_mp_usage)

        @skill_owner.turnable.reduce_turn_amount(use_turn)
        @skill_owner.mp_usable.use_mp(use_mp)

        damage = SkillDamage.new(self.calculate_damage, creature)
        damage.has_effects = [Silenced.new(1)]
        
        creature.damageable.take_damage(damage)
    end

    def can_use_skill?(creature)
        @skill_owner.effects.find_effect(TransformBatBuff) && @skill_owner.mp.current_mp >= @skill_mp_usage && @action_time <= @skill_owner.turns.current_turn
    end

    def name_display
        self.skill_display_helper(
            skill_name: @name,
            action_time: @action_time,
            skill_mp_usage: @skill_mp_usage,
            can_use_skill: can_use_skill?(@skill_owner),
        )
    end
end