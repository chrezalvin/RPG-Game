require "Parents/Skill"
require "Effects/Parrying"

class Parry < Skill

  @skill_mp_usage = 15
  @description = "Shield yourself against incoming damage, apply Parrying effect until you take damage, uses #{@skill_mp_usage} mana"
  @name = "Parry"
  def initialize(skill_owner)
    super(skill_owner)
  end

  def self.skill_mp_usage
    @skill_mp_usage
  end

  def can_use_skill?(creature)
    @skill_owner.current_mp >= self.class.skill_mp_usage
  end

  def use_skill(creature)
    if super(creature)
      @skill_owner.use_mp(self.class.skill_mp_usage)

      effect = Parrying.new()
      
      effect.apply_effect(@skill_owner)
    end
  end
end