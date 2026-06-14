require "Parents/Action/Skill"
require "Effects/Quick"

class Quicken < Skill
  attr_accessor :skill_mp_usage, :stack_gain

  def initialize(skill_owner)
    super(
      skill_owner: skill_owner,
      name: "Quicken",
      description: "Gain Quick stacks, each stack reduces the turn amount by 1, max 5 stacks",
    )

    @skill_mp_usage = 25
    @stack_gain = 3
  end

  def use_skill(creature)
    if !super(creature)
        return
    end

    use_turn = UseTurn.new(@action_time)
    use_mp = MpUse.new(@skill_mp_usage)

    @skill_owner.turnable.reduce_turn_amount(use_turn)
    @skill_owner.mp_usable.use_mp(use_mp)

    effect = Quick.new(@stack_gain)

    @skill_owner.effectable.apply_effect(effect)
  end

  def can_use_skill?(creature)
    @skill_owner.mp.current_mp >= @skill_mp_usage && self.action_time <= @skill_owner.turns.current_turn
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