require "Parents/Action/Skill"
require "Damages/SkillDamage"

class MagicMissle < Skill
  attr_accessor :skill_mp_usage, :damage_multiplier

  def initialize(skill_owner)
    super(
      skill_owner: skill_owner,
      name: "Magic Missle",
      description: "Cast a missle made out of magic, deals magic damage based on your matk",
    )

    @skill_mp_usage = 30
    @damage_multiplier = 2
    
    self.calculate_damage = (@damage_multiplier * @skill_owner.matk.matk_amount).to_i
  end

  def use_skill(creature)
    if !super(creature)
        return
    end

    use_turn = UseTurn.new(@action_time)
    use_mp = MpUse.new(@skill_mp_usage)

    @skill_owner.turnable.reduce_turn_amount(use_turn)
    @skill_owner.mp_usable.use_mp(use_mp)
    
    skillDamage = SkillDamage.new(self.calculate_damage, @skill_owner)

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

  def can_use_skill?(creature)
    @skill_owner.mp.current_mp >= @skill_mp_usage && @action_time <= @skill_owner.turns.current_turn
  end
end