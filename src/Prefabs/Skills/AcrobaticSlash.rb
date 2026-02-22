require_relative "../../Parents/Skill"
require_relative "../Damages/SkillDamage"

class AcrobaticSlash < Skill
    @damage_multiplier = 1.5
    @skill_mp_usage = 10
    @name = "Acrobatic Slash"
    @description = "A series of slash midair, dealing #{@damage_multiplier}x of caster's Atk, uses #{@skill_mp_usage} MP"
    def initialize(skill_owner)
      super(skill_owner)
    end

    def self.skill_mp_usage
      @skill_mp_usage
    end

    def self.damage_multiplier
      @damage_multiplier
    end

    def can_use_skill?(creature)
      @skill_owner.current_mp >= self.class.skill_mp_usage
    end

    def use_skill(creature)
      if super(creature)
        @skill_owner.use_mp(self.class.skill_mp_usage)

        damage_amount = (self.class.damage_multiplier * @skill_owner.atk_amount).to_i
        skillDamage = SkillDamage.new(damage_amount, @skill_owner)

        skillDamage.apply_to(creature)
      end
    end
end