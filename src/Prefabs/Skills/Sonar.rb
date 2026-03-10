require "Parents/Skill"
require "Damages/SkillDamage"
require "Effects/Silenced"

class Sonar < Skill

    @damage_multiplier_percentage = 60
    @skill_mp_usage = 20
    @name = "Sonar"
    @description = "[Requires bat form] Attack the enemy with sound waves, deals #{@damage_multiplier_percentage}% of total MATK, apply silence"
    def initialize(skill_owner)
        super(skill_owner)
    end

    def self.damage_multiplier_percentage
        @damage_multiplier_percentage
    end

    def can_use_skill?(creature)
        @skill_owner.find_effect(TransformBatBuff) && @skill_owner.current_mp >= self.class.skill_mp_usage
    end

    def use_skill(creature)
        if super(creature)
            @skill_owner.use_mp(self.class.skill_mp_usage)

            damage_amount = (@skill_owner.matk.matk_amount * self.class.damage_multiplier_percentage / 100).to_i
            damage = SkillDamage.new(damage_amount, creature)
            damage.has_effects = [Silenced.new(1)]
            
            damage.apply_to(creature)
        end
    end
end