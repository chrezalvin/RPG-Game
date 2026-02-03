require_relative "./Skill"
require_relative "../Damages/BasicDamage"

class HeavySwing < Skill
    def initialize(skill_owner)
        super(skill_owner)

        @description = "A classic heavy swing commonly used by warrior"
        @damage = @skill_owner.atk
        @name = "Heavy Swing"
    end

    def get_skill_damage
        @skill_owner.atk * 2
    end

    def can_use_skill?(creature)
        true
    end

    def use_skill(creature)
        super(creature)
    
        creature.take_damage(BasicDamage.new(get_skill_damage, creature))
    end
end