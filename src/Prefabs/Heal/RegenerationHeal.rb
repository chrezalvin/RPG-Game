require "Parents/ActionProfile/Heal"

class RegenerationHeal < Heal
    def initialize(healer)
        super(healer.nhpr.natural_hp_regen, healer, false)
        @heal_type = "regeneration"
    end
end