require_relative "../../../Parents/Creature"
require_relative "../../Skills/HeavySwing"
require_relative "../../Skills/BasicAttack"
require_relative "../../Skills/BasicHeal"

class Viking < Creature

    @@description = "An ancient warrior"
    def initialize()
        super()
        @name = "Viking"
        @basic_attack = BasicAttack.new(self)
        @usable_skills = [HeavySwing.new(self), BasicHeal.new(self)]
    end
end