require "Parents/Skill"
require "Damages/SkillDamage"
require "Damages/LifeStealDamage"
require "Heal/BasicHeal"

class Vampirism < Skill

    @skill_heal_multiplier_percentage = 50
    @skill_mp_usage = 30
    @name = "Vampirism"
    @description = "Deals damage to the enemy proportional to your ATK and heal yourself for #{@skill_heal_multiplier_percentage}% of the damage dealt"
    def initialize(skill_owner)
        super(skill_owner)
    end

    def self.skill_heal_multiplier_percentage
        @skill_heal_multiplier_percentage
    end

    def can_use_skill?(creature)
        @skill_owner.current_mp >= self.class.skill_mp_usage
    end

    def use_skill(creature)
        if super(creature)            
            @skill_owner.use_mp(self.class.skill_mp_usage)

            damage_amount = @skill_owner.atk.atk_amount
            lifestealDamage = LifeStealDamage.new(
                amount: damage_amount,
                damage_dealer: @skill_owner,
                damage_type: "skill",
                lifesteal_percentage: self.class.skill_heal_multiplier_percentage
            )

            lifestealDamage.apply_to(creature)
        end
    end
end