require "Parents/Damage"

class TrueDamage < Damage
    def initialize(amount, damage_dealer)
        super(amount, damage_dealer, false)
        @damage_type = "true"
    end
end