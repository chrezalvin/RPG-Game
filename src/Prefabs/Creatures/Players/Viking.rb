require_relative "../../../Parents/Creature"
require_relative "../../Skills/HeavySwing"
require_relative "../../Skills/BasicAttack"
require_relative "../../Skills/BasicHeal"
require_relative "../../Skills/Guard"
require_relative "../../Effects/Thorns"

class Viking < Creature

    @description = "An ancient warrior"
    @name = "Viking"
    @chance_to_use_skill = 0.5
    def initialize()
        super(hp: 100, mp: 80, atk: 25, matk: 15, nmpr: 10, nhpr: 10)
        @basic_attack = BasicAttack.new(self)
        @effects = []
        @usable_skills = [
            HeavySwing.new(self), 
            BasicHeal.new(self),
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