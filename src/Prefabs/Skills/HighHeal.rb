require_relative "../../Parents/Skill"

class HighHeal < Skill

  @skill_mp_usage = 15
  @skill_hp_heal_percentage = 30
  @description = "Great Heal! heal #{@skill_hp_heal_percentage}% of your hp, uses #{@skill_mp_usage} mana"
  @name = "Great Heal"
  def initialize(skill_owner)
    super(skill_owner)
  end

  def self.skill_mp_usage
    @skill_mp_usage
  end

  def self.skill_hp_heal_percentage
    @skill_hp_heal_percentage
  end

  def can_use_skill?(creature)
    @skill_owner.current_mp >= self.class.skill_mp_usage
  end

  def use_skill(creature)
    if super(creature)
      @skill_owner.use_mp(self.class.skill_mp_usage)
      @skill_owner.heal((@skill_owner.max_hp * self.class.skill_hp_heal_percentage / 100).to_i)
    end
  end
end