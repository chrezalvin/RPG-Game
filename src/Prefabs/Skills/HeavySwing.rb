require "Parents/Skill"
require "Damages/SkillDamage"
require "Sounds/SwordSliceSound"

class HeavySwing < Skill
    @skill_mp_usage = 10
    @damage_multiplier = 2
    @description = "A classic heavy swing commonly used by warrior, uses #{@skill_mp_usage} mana, dealing #{@damage_multiplier}x of caster's Atk"
    @name = "Heavy Swing"
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

            @skill_owner.make_sound(SwordSliceSound.new())
            skillDamage.apply_to(creature)
        end
    end
end