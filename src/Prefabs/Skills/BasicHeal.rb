require_relative "../../Parents/Skill"
require_relative "../Damages/BasicDamage"

class BasicHeal < Skill
  def initialize(skill_owner)
    super(skill_owner)

    @skill_mp_usage = 10
    @skill_hp_heal_percentage = 20
    @description = "Basic Healing, heal #{@skill_hp_heal_percentage}% of your hp, uses #{@skill_mp_usage} mana"
    @name = "Basic Heal"
  end

  def can_use_skill?(creature)
    @skill_owner.current_mp >= @skill_mp_usage
  end

  def use_skill(creature)
    if super(creature)
      @skill_owner.use_mp(@skill_mp_usage)
      creature.heal((creature.max_hp * @skill_hp_heal_percentage / 100).to_i)
    end
  end
end