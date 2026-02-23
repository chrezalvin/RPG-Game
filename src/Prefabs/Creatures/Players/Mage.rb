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
        super(atk: 5, matk: 30, hp: 80, mp: 200, nmpr: 20, nhpr: 10)
        @basic_attack = BasicAttack.new(self)
        @usable_skills = [
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