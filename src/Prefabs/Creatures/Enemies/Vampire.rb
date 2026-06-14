require "Parents/Creature"

require "Skills/BasicAttack"
require "Skills/Vampirism"
require "Skills/TransformBat"
require "Skills/RazorClaw"
require "Skills/Sonar"
require "Damages/BasicDamage"

require "Effects/TransformBatBuff"


class Vampire < Creature
    @name = "Vampire"
    @description = "An undead creature that feeds on blood"
    @chance_to_use_skill = 0.7
    def initialize
        super(
            hp: 60, 
            mp: 200, 
            atk: 10, 
            matk: 20, 
            nmpr: 20,
            nhpr: 10,
            defense: 10,
            dodge: 20,
            acc: 10,
            speed: 5
        )

        @usable_skills = [
            BasicAttack,
            Vampirism,
            TransformBat,
            RazorClaw,
            Sonar
        ]
    end

    def self.chance_to_use_skill
        @chance_to_use_skill
    end

    def decide_next_action(creature)
        super(creature)

        if creature.turns.turn_amount <= 0
            return -1
        end

        if rand < self.class.chance_to_use_skill
            # prefer sonar if available and vampire is in bat form
            if creature.find_effect(TransformBatBuff)
                sonar_idx = self.find_skill(Sonar)
                unless sonar_idx.nil? && self.skill(sonar_idx).can_use_skill?(creature)
                    return sonar_idx
                end
            end

            # otherwise, pick a random skill
            random_idx = rand(@usable_skills.length)
            if skills.fetch(random_idx).can_use_skill?(creature)
                return random_idx
            end
        end

        return 0
    end
end