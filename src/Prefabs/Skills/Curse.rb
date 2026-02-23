require "Parents/Skill"
require "Effects/Cursed"

class Curse < Skill

  @skill_mp_usage = 20
  @description = "Curses the target, reducing the next heal, uses #{@skill_mp_usage} mana"
  @name = "Curse"
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

      effect = Cursed.new()
      
      effect.apply_effect(creature)
    end
  end
end