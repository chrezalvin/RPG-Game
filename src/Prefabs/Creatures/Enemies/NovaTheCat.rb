require "Parents/Creature"

require "Skills/BasicAttack"
require "Skills/RazorClaw"

class NovaTheCat < Creature
    @name = "Nova the Cat"
    @description = nil
    @chance_to_use_skill = 0.3
    def initialize
        super(
            hp: 100, 
            mp: 35, 
            atk: 41, 
            matk:0, 
            nmpr: 1, 
            nhpr: 10, 
            dodge: 5,
            defense: 0,
            acc: 20, 
            speed: 14
        )
        @usable_skills = [
            BasicAttack, 
            RazorClaw
        ]
    end

    def self.chance_to_use_skill
        @chance_to_use_skill
    end

    def decide_next_action(creature)
        # super(creature)
        
        if self.turns.turn_amount <= 0
            return -1
        end
        
        skills = self.skills.skills
        random_idx = rand(skills.length)
        if rand < self.class.chance_to_use_skill
            skill = skills.fetch(random_idx)
            if skill.can_use_skill?(creature)
                self.skill_usable.use_skill(skill)
            end
        else
            self.skill_usable.use_skill(skills[0])
        end
    end
end