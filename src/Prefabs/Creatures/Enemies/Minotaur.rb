require "Parents/Creature"
require "Parents/Actionable/SkillUsable"

require "Skills/BasicAttack"
require "Skills/HeavySwing"

class Minotaur < Creature
    @name = "Minotaur"
    @description = nil
    @chance_to_use_skill = 0.3
    def initialize
        super(
            hp: 100, 
            mp: 20, 
            atk: 10, 
            matk: 10, 
            nmpr: 5, 
            nhpr: 5, 
            acc: 10,
            defense: 7, 
            speed: 5
        )

        @skills = Skills.new(
            [
                BasicAttack,
                HeavySwing
            ],
            self
        )
    end

    def self.chance_to_use_skill
        @chance_to_use_skill
    end

    def decide_next_action(creature)
        # super(creature)
        
        if self.turns.current_turn <= 0
            return -1
        end
        
        skills = self.skills.skills
        random_idx = rand(skills.length)
        if rand < self.class.chance_to_use_skill
            skill = skills.fetch(random_idx)
            if skill.can_use_skill?(creature)
                self.skill_usable.use_skill(skill, creature)
            end
        else
            self.skill_usable.use_skill(skills[0], creature)
        end
    end
end