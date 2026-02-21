require_relative "../../Skills/BasicAttack"
require_relative "../../../Parents/Creature"

class Mummy < Creature
    @name = "Mummy"
    @description = "An undead creature"
    def initialize
        super(hp: 30, mp: 200, atk: 5, matk: 20, nmpr: 20, nhpr: 10)
        @basic_attack = BasicAttack.new(self)
        @usable_skills = []
    end

    def heal(amount)
        @hp.take_damage(amount)
    end

    def decide_next_action(creature)
        super(creature)

        return @basic_attack
    end
end