require "Parents/Creature"

require "Skills/BasicAttack"
require "Skills/HeavySwing"

class Minotaur < Creature
    @name = "Minotaur"
    @description = nil
    @chance_to_use_skill = 0.3
    def initialize
        super(hp: 100, mp: 20, atk: 10, matk: 10, nmpr: 5, nhpr: 5)
        @basic_attack = BasicAttack.new(self)
        @usable_skills = [HeavySwing.new(self)]
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