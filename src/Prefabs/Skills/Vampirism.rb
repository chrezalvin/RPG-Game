require "Parents/Skill"
require "Damages/SkillDamage"
require "Heal/BasicHeal"

class Vampirism < Skill

    @skill_heal_multiplier_percentage = 50
    @skill_mp_usage = 30
    @name = "Vampirism"
    @description = "Deals damage to the enemy proportional to your ATK and heal yourself for #{@skill_heal_multiplier_percentage}% of the damage dealt, uses #{@skill_mp_usage} mana"
    def initialize(skill_owner)
        super(skill_owner)
    end

    def self.skill_heal_multiplier_percentage
        @skill_heal_multiplier_percentage
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

            damage_amount = @skill_owner.atk_amount.to_i
            skillDamage = SkillDamage.new(damage_amount, @skill_owner)

            skillDamage.apply_to(creature)

            heal_amount = (damage_amount * self.class.skill_heal_multiplier_percentage / 100).to_i
            healInstance = BasicHeal.new(heal_amount, @skill_owner)

            healInstance.apply_to(@skill_owner)
        end
    end
end