require_relative "../../Parents/Skill"
require_relative "../Damages/SkillDamage"

class MagicArrows < Skill

  @skill_mp_usage = 30
  @skill_damage_multiplier = 0.5
  @description = "Cast three arrows made out of magic, each arrow deals #{@skill_damage_multiplier}x of caster's Matk, uses #{@skill_mp_usage} mana"
  @name = "Magic Arrows"
  def initialize(skill_owner)
    super(skill_owner)
  end

  def self.skill_mp_usage
    @skill_mp_usage
  end

  def self.skill_damage_multiplier
    @skill_damage_multiplier
  end

  def can_use_skill?(creature)
    @skill_owner.current_mp >= self.class.skill_mp_usage
  end

  def use_skill(creature)
    if super(creature)
      @skill_owner.use_mp(self.class.skill_mp_usage)
      for i in 1..3
        skillDamage = SkillDamage.new((@skill_owner.matk.matk_amount * self.class.skill_damage_multiplier).to_i, @skill_owner)
        creature.take_damage(skillDamage)
      end
    end
  end
end