require "Parents/Action/Skill"
require "Damages/SkillDamage"
require "Sounds/SwordSliceSound"
require "Effects/Art"
require "Effects/ArmorBreak"

class HeavySwing < Skill
    attr_accessor :damage_multiplier, :skill_mp_usage

    def initialize(skill_owner)
        super(
            skill_owner: skill_owner,
            name: "Heavy Swing",
            description: "A classic heavy swing commonly used by warrior, applies 1 stack of Armor Break on hit",
        )

        @skill_mp_usage = 20
        @damage_multiplier = 3
    end

    def calculate_damage
        (@damage_multiplier * @skill_owner.atk.atk).to_i
    end

    def use_skill(creature)
        if !super(creature)
            return
        end

        use_mp = MpUse.new(@skill_mp_usage)
        use_turn = UseTurn.new(@action_time)

        @skill_owner.mp_usable.use_mp(use_mp)
        @skill_owner.turnable.reduce_turn_amount(use_turn)

        skillDamage = SkillDamage.new(self.calculate_damage, @skill_owner)
        skillDamage.has_effects = [ArmorBreak.new()]

        creature.damageable.take_damage(skillDamage)
    end

    def name_display
        self.skill_display_helper(
            skill_name: @name,
            action_time: @action_time,
            skill_mp_usage: @skill_mp_usage,
            can_use_skill: can_use_skill?(@skill_owner),
        )
    end

    def can_use_skill?(_)
        @skill_owner.mp.current_mp <= @skill_mp_usage && @action_time <= @skill_owner.turns.current_turn
    end
end