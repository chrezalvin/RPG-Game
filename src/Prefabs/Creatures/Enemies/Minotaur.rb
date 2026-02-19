require_relative "../../Skills/BasicAttack"
require_relative "../../../Parents/Creature"

class Minotaur < Creature
    def initialize
        super()
        @name = "Minotaur"
        @basic_attack = BasicAttack.new(self)
    end
end