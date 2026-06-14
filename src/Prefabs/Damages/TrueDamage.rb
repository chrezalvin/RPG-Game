require "Parents/ActionProfile/Damage"

class TrueDamage < Damage
    def initialize(amount, damage_dealer)
        super(amount, damage_dealer)
        @damage_type = "true"
    end
end