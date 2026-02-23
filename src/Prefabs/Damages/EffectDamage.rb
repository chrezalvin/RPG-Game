require "Parents/Damage"

class EffectDamage < Damage
    def initialize(amount)
        super(amount, nil, true)
        @damage_type = "thorns"
    end
end