require "Parents/Creature"

require "Skills/HighHeal"
require "Skills/BasicHealing"
require "Skills/MagicMissle"
require "Skills/MagicArrows"
require "Skills/BasicAttack"

class Mage < Creature

    @description = "A magician specializing in magic attacks"
    @name = "Mage"
    @chance_to_use_skill = 0.5
    def initialize()
        super(
            atk: 5, 
            matk: 30, 
            hp: 80, 
            mp: 200, 
            defense: 3,
            nmpr: 20, 
            nhpr: 10, 
            acc: 10,
            speed: 5,
            dodge: 5
        )
        @usable_skills = [
            BasicAttack.new(self),
            HighHeal.new(self), 
            BasicHealing.new(self), 
            MagicMissle.new(self), 
            MagicArrows.new(self)
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