require "Parents/Creature"

require "Skills/Vampirism"

class Joe < Creature

    @description = "Your average Joe"
    @name = "Joe"
    @chance_to_use_skill = 0.5
    def initialize()
        super(atk: 10, matk: 10, hp: 100, mp: 100, nmpr: 10, nhpr: 10)
        @basic_attack = BasicAttack.new(self)
        @usable_skills = [
            Vampirism.new(self)
        ]
    end

    def self.chance_to_use_skill
        @chance_to_use_skill
    end

    def decide_next_action(creature)
        unless creature.is_a? Creature
            throw "Error: creature must be an instance of Creature, got #{creature.class}"
        end

        if rand < self.class.chance_to_use_skill
            skill = @usable_skills.sample
            if skill.can_use_skill?(creature)
                return skill
            end
        end

        return @basic_attack
    end
end