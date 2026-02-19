require_relative "../../Parents/Skill"
require_relative "../Damages/BasicDamage"

class BasicAttack < Skill
  def initialize(skill_owner)
    super(skill_owner)

    @damage = @skill_owner.atk.atk_amount
    @name = "Basic Attack"
  end

  def can_use_skill?(creature)
    true
  end

  def use_skill(creature)
    super(creature)

    creature.take_damage(BasicDamage.new(@damage, @skill_owner))
  end
end