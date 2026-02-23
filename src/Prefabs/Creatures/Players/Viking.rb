require "Parents/Creature"

require "Skills/HeavySwing"
require "Skills/BasicAttack"
require "Skills/BasicHealing"
require "Skills/Guard"
require "Effects/Thorns"

class Viking < Creature

    @description = "An ancient warrior"
    @name = "Viking"
    @chance_to_use_skill = 0.5
    def initialize()
        super(hp: 100, mp: 80, atk: 20, matk: 10, nmpr: 10, nhpr: 10)
        @basic_attack = BasicAttack.new(self)
        @effects = []
        @usable_skills = [
            HeavySwing.new(self), 
            BasicHealing.new(self),
            Guard.new(self)
        ]
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