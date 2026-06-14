require "Parents/ActionProfile/Damage"

class EffectDamage < Damage
    def initialize(amount, damage_dealer)
        super(amount, damage_dealer)
        @damage_type = "thorns"
    end
end