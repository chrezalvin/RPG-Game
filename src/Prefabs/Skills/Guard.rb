require "Parents/Skill"
require "Effects/Shielded"

class Guard < Skill

  @skill_mp_usage = 5
  @description = "Shield yourself against incoming damage, apply Shielded effect until you take damage"
  @name = "Guard"
  def initialize(skill_owner)
    super(skill_owner)
  end

  def can_use_skill?(creature)
    @skill_owner.current_mp >= self.class.skill_mp_usage
  end

  def use_skill(_)
    if super(_)
      @skill_owner.use_mp(self.class.skill_mp_usage)

      effect = Shielded.new()

      effect.apply_effect(@skill_owner)
    end
  end
end