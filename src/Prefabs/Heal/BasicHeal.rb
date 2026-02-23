require "Parents/Heal"

class BasicHeal < Heal
    def initialize(heal_amount, healer)
        super(heal_amount, healer, false)
        @heal_type = "basic"
    end
end