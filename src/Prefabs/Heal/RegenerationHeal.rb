require "Parents/Heal"

class RegenerationHeal < Heal
    def initialize(heal_amount)
        super(heal_amount, nil, false)
        @heal_type = "regeneration"
    end
end