require "Parents/ActionProfile/Damage"

class BasicDamage < Damage
    def initialize(amount, damage_dealer)
        super(amount, damage_dealer)
        @damage_type = "basic"
    end
end