require_relative "../Creature"
require_relative "../../Skills/BasicAttack"

class NovaTheCat < Creature
    def initialize
        super()
        @name = "Nova the Cat"
        @atk = 36
        @hp = 100
        @mp = 35
        @basic_attack = BasicAttack.new(self)
    end
end