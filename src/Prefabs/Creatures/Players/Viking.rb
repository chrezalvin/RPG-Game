require "Parents/Creature"

require "Skills/HeavySwing"
require "Skills/BasicAttack"
require "Skills/BasicHealing"
require "Skills/Guard"
require "Skills/Parry"
require "Effects/Thorns"

class Viking < Creature
    @description = "An ancient warrior"
    @name = "Viking"
    @chance_to_use_skill = 0.5
    def initialize()
        super(
            hp: 100,
            mp: 80,
            atk: 20,
            matk: 10,
            nmpr: 10,
            nhpr: 10,
            dodge: 10, 
            defense: 7,
            acc: 10,
            speed: 5
        )

        @effects = []
        @usable_skills = [
            BasicAttack.new(self),
            HeavySwing.new(self), 
            BasicHealing.new(self),
            Guard.new(self),
            Parry.new(self)
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