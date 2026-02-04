require_relative "../Creature"
require_relative "../../Skills/HeavySwing"
require_relative "../../Skills/BasicAttack"

class Viking < Creature
    def initialize()
        super()
        @name = "Viking"
        @basic_attack = BasicAttack.new(self)
        @usable_skills = [HeavySwing.new(self)]
    end
end