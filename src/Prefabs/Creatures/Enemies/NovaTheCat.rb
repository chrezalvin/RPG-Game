# require_relative "../Creature"
require_relative "../../Skills/BasicAttack"

require_relative "../../../Parents/Creature"
require_relative "../../../Parents/Atk"
require_relative "../../../Parents/Hp"
require_relative "../../../Parents/Mp"

class NovaTheCat < Creature
    def initialize
        super()
        @name = "Nova the Cat"
        @atk = Atk.new(36)
        @hp = Hp.new(100)
        @mp = Mp.new(35)
        @basic_attack = BasicAttack.new(self)
    end
end