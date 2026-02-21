require_relative "../../Parents/Damage"

class BasicDamage < Damage
    def initialize(amount, damage_dealer)
        super(amount, damage_dealer, false)
        @damage_type = "basic"
    end
end