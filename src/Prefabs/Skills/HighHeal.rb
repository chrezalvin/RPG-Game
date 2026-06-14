require "Parents/Action/Skill"
require "Heal/BasicHeal"

class HighHeal < Skill
  attr_accessor :skill_mp_usage, :skill_hp_heal_percentage

  def initialize(skill_owner)
    super(
      skill_owner: skill_owner,
      name: "High Heal",
      description: "Great Heal! heal large amount of hp based on percentage of max hp",
    )

    @skill_mp_usage = 15
    @skill_hp_heal_percentage = 30

    @calculate_heal_amount = (@skill_owner.max_hp * @skill_hp_heal_percentage / 100).to_i
  end

  def use_skill(creature)
    if !super(creature)
        return
    end

    use_turn = UseTurn.new(@action_time)
    use_mp = MpUse.new(@skill_mp_usage)

    @skill_owner.turnable.reduce_turn_amount(use_turn)
    @skill_owner.mp_usable.use_mp(use_mp)

    heal = BasicHeal.new(@calculate_heal_amount, @skill_owner)

    @skill_owner.healable.heal(heal)
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

  def can_use_skill?(creature)
    @skill_owner.mp.current_mp >= self.skill_mp_usage && self.action_time <= @skill_owner.turns.current_turn
  end
end