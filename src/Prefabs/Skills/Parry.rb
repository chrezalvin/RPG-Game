require "Parents/Action/Skill"
require "Effects/Parrying"

class Parry < Skill
  attr_accessor :art_requirement

  def initialize(skill_owner)
    super(
      skill_owner: skill_owner,
      name: "Parry",
      description: "Shield yourself against incoming damage, apply Parrying effect until you take damage or use a skill",
    )

    @art_requirement = 3
    @mp_requirement = 20
  end

  def use_skill(_)
    if !super(_)
        return
    end

    use_turn = UseTurn.new(@action_time)
    use_mp = MpUse.new(@mp_requirement)

    @skill_owner.turnable.reduce_turn_amount(use_turn)
    @skill_owner.mp_usable.use_mp(use_mp)

    effect = Parrying.new()

    @skill_owner.effectable.apply_effect(effect)
  end

  def name_display
    self.skill_display_helper(
      skill_name: @name,
      action_time: @action_time,
      skill_mp_usage: @mp_requirement,
      can_use_skill: can_use_skill?(@skill_owner),
    )
  end

  def can_use_skill?(creature)
    @skill_owner.mp.current_mp >= @mp_requirement && @action_time <= @skill_owner.turns.current_turn
  end
end