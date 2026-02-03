require_relative "../Creature"

class NovaTheCat < Creature
    def initialize
        super()
        @name = "Nova the Cat"
        @atk = 36
        @hp = 100
        @mp = 35
    end
end