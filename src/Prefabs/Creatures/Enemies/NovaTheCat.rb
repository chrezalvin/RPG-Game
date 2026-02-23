require "Parents/Creature"

require "Skills/BasicAttack"
require "Skills/RazorClaw"

class NovaTheCat < Creature
    @name = "Nova the Cat"
    @description = nil
    @chance_to_use_skill = 0.3
    def initialize
        super(hp: 100, mp: 35, atk: 36, matk:0, nmpr: 1, nhpr: 10)
        @basic_attack = BasicAttack.new(self)
        @usable_skills = [RazorClaw.new(self)]
    end

    def self.chance_to_use_skill
        @chance_to_use_skill
    end

    def decide_next_action(creature)
        super(creature)

        if rand < self.class.chance_to_use_skill
            skill = @usable_skills.sample
            if skill.can_use_skill?(creature)
                return skill
            end
        end

        return @basic_attack
    end
end