require_relative "../../Parents/Skill"
require_relative "../Damages/TrueDamage"

class RazorClaw < Skill

    @damage_multiplier = 1.2
    @skill_mp_usage = 10
    @name = "Razor Claw"
    @description = "Swift slash with her claws, very fast and never misses"
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

            damage_amount = (@skill_owner.atk_amount * self.class.damage_multiplier).to_i
            damage = TrueDamage.new(damage_amount, creature)

            damage.apply_to(creature)
        end
    end
end