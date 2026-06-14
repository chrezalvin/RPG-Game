require "Parents/Action/Skill"
require "Damages/BasicDamage"
require "MpHeals/RegenerationMpHeal"

class BasicAttack < Skill
  def initialize(skill_owner)
    super(
      skill_owner: skill_owner,
      name: "Basic Attack",
      description: "A basic attack, deals #{skill_owner.atk.atk_colorized} dmg and regenerates #{skill_owner.nmpr.natural_mp_regen} mp",
    )
  end

  def name_display
    self.skill_display_helper(
      skill_name: @name,
      action_time: @action_time,
      can_use_skill: can_use_skill?(@skill_owner),
    )
  end

  def can_use_skill?(creature)
    @action_time <= @skill_owner.turns.current_turn
  end

  def use_skill(creature)
    if !super(creature)
        return
    end

    use_turn = UseTurn.new(@action_time)

    damage_amount = @skill_owner.atk.atk
    basicDamage = BasicDamage.new(damage_amount, @skill_owner)
    regenerateMpHeal = RegenerationMpHeal.new(@skill_owner)

    @skill_owner.turnable.reduce_turn_amount(use_turn)
    creature.damageable.take_damage(basicDamage)
    creature.mp_healable.heal_mp(regenerateMpHeal)
  end
end