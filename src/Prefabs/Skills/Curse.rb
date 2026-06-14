require "Parents/Action/Skill"
require "Effects/Cursed"

class Curse < Skill
  attr_accessor :skill_mp_usage

  def initialize(skill_owner)
    super(
      skill_owner: skill_owner,
      name: "Curse",
      description: "Curses the target, reducing the next heal",
    )

    @skill_mp_usage = 20
  end

  def use_skill(creature)
    if !super(creature)
        return
    end

    use_turn = UseTurn.new(@action_time)
    use_mp = MpUse.new(@skill_mp_usage)

    @skill_owner.turnable.reduce_turn_amount(use_turn)
    @skill_owner.mp_usable.use_mp(use_mp)

    effect = Cursed.new()

    creature.effectable.apply_effect(effect)
  end

  def can_use_skill?(creature)
    @skill_owner.mp.current_mp >= @skill_mp_usage && @action_time <= @skill_owner.turns.current_turn
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