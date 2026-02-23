require "Parents/Skill"
require "Heal/BasicHeal"

class BasicHealing < Skill
  @skill_mp_usage = 10
  @skill_hp_heal_percentage = 15
  @description = "Heals #{@skill_hp_heal_percentage}% of your hp, uses #{@skill_mp_usage} mana"
  @name = "Basic Healing"
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

      heal = BasicHeal.new((@skill_owner.max_hp * self.class.skill_hp_heal_percentage / 100).to_i, @skill_owner)

      heal.apply_to(@skill_owner)
    end
  end
end