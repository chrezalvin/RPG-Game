require_relative "../../Skills/BasicAttack"
require_relative "../../Skills/AcrobaticSlash"
require_relative "../../../Parents/Creature"

class GiantSpider < Creature
    @description = nil
    @name = "Giant Spider"
    @chance_to_use_skill = 0.5
    def initialize
        super(hp: 60, mp: 60, atk: 5, matk: 20, nmpr: 10, nhpr: 10)
        @basic_attack = BasicAttack.new(self)
        @usable_skills = [AcrobaticSlash.new(self)]
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