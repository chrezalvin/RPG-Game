require "Parents/Creature"

require "Skills/Vampirism"
require "Skills/TransformBat"

class Joe < Creature

    @description = "Your average Joe"
    @name = "Joe"
    @chance_to_use_skill = 0.5
    def initialize()
        super(atk: 10, matk: 10, hp: 100, mp: 100, nmpr: 10, nhpr: 10)
        @usable_skills = [
            BasicAttack.new(self),
            Vampirism.new(self),
            TransformBat.new(self)
        ]
    end

    def self.chance_to_use_skill
        @chance_to_use_skill
    end
    
    def decide_next_action(creature)
        super(creature)

        if rand < self.class.chance_to_use_skill
            random_idx = rand(@usable_skills.length)
            skill = self.skill(random_idx)
            if skill.can_use_skill?(creature)
                return random_idx
            end
        end

        return 0
    end
end