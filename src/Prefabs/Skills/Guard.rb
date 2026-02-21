require_relative "../../Parents/Skill"
require_relative "../Effects/Shielded"

class Guard < Skill

  @skill_mp_usage = 5
  @description = "Gives yourself Shielded effect"
  @name = "Guard"
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
      @skill_owner.apply_effect(Shielded.new())
    end
  end
end