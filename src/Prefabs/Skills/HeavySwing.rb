require_relative "../../Parents/Skill"
require_relative "../Damages/SkillDamage"

class HeavySwing < Skill
    def initialize(skill_owner)
        super(skill_owner)

        @description = "A classic heavy swing commonly used by warrior"
        @damage = @skill_owner.atk.atk_amount
        @name = "Heavy Swing"
    end

    def get_skill_damage
        @skill_owner.atk.atk_amount * 2
    end

    def can_use_skill?(creature)
        true
    end

    def use_skill(creature)
        if super(creature)
            skill = SkillDamage.new(get_skill_damage, creature)
            creature.take_damage(skill)
        end
    end
end