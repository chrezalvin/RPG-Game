require "Parents/Action/Skill"
require "Effects/Shielded"

class Guard < Skill
  attr_accessor :skill_mp_usage, :art_requirement

  def initialize(skill_owner)
    super(
      skill_owner: skill_owner,
      name: "Guard",
      description: "Shield yourself against incoming damage, apply Shielded effect until you take damage",
    )

    @skill_mp_usage = 20
    @art_requirement = 3
  end

  def use_skill(_)
    if !super(_)
        return
    end

    use_turn = UseTurn.new(@action_time)
    use_mp = MpUse.new(@skill_mp_usage)

    @skill_owner.turnable.reduce_turn_amount(use_turn)
    @skill_owner.mp_usable.use_mp(use_mp)
    
    effect = Shielded.new()

    @skill_owner.effectable.apply_effect(effect)
  end

  def can_use_skill?(creature)
    @skill_owner.mp.current_mp >= @skill_mp_usage && @action_time <= @skill_owner.turns.current_turn
  end

  def name_display
    return self.skill_display_helper(
      skill_name: @name,
      action_time: @action_time,
      skill_mp_usage: @skill_mp_usage,
      can_use_skill: can_use_skill?(@skill_owner),
      art_requirement: nil
    )
  end
end