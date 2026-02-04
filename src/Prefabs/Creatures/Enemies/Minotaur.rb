require_relative "../Creature"
require_relative "../../Skills/BasicAttack"

class Minotaur < Creature
    def initialize
        super()
        @name = "Minotaur"
        @basic_attack = BasicAttack.new(self)
    end
end