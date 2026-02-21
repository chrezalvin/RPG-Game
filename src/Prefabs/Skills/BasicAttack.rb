require_relative "../../Parents/Skill"
require_relative "../Damages/BasicDamage"

class BasicAttack < Skill

  @name = "Basic Attack"
  @description = "A basic attack, dealing damage equal to your Atk, regenerates mp afterwards"
  def initialize(skill_owner)
    super(skill_owner)
  end

  def can_use_skill?(creature)
    true
  end

  def use_skill(creature)
    if super(creature)
      creature.take_damage(BasicDamage.new(@skill_owner.atk.atk_amount, @skill_owner))
      @skill_owner.regenerate_mp
    end
  end
end