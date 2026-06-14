require "Parents/Action/Skill"
require "Parents/ActionProfile/UseTurn"
require "Parents/ActionProfile/MpUse"
require "Damages/SkillDamage"

class AcrobaticSlash < Skill
  attr_accessor :skill_mp_usage, :damage_multiplier

  def initialize(skill_owner)
    super(
      skill_owner: skill_owner,
      name: "Acrobatic Slash",
      description: "A series of slash midair",
    )

    @skill_mp_usage = 10
    @damage_multiplier = 1.5
  end

  def can_use_skill?(creature)
    @skill_owner.mp.current_mp >= @skill_mp_usage && @action_time <= @skill_owner.turns.current_turn
  end

  def use_skill(creature)
    if !super(creature)
        return
    end

    use_turn = UseTurn.new(@action_time)
    use_mp = MpUse.new(@skill_mp_usage)

    damage_amount = (@damage_multiplier * @skill_owner.atk.atk).to_i
    skillDamage = SkillDamage.new(damage_amount, @skill_owner)

    @skill_owner.turnable.reduce_turn_amount(use_turn)
    @skill_owner.mp_usable.use_mp(use_mp)
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
end