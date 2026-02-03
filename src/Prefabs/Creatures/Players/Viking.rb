require_relative "../Creature"
require_relative "../../Skills/HeavySwing"

class Viking < Creature
    def initialize()
        super()
        @name = "Viking"
        @usable_skills = [HeavySwing.new(self)]
    end
end