require "Parents/Skill"
require "Damages/BasicDamage"

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
      damage_amount = @skill_owner.atk_amount
      basicDamage = BasicDamage.new(damage_amount, @skill_owner)

      basicDamage.apply_to(creature)
      @skill_owner.regenerate_mp
    end
  end
end