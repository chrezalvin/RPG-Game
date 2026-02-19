require_relative "../../Parents/Damage"

class SkillDamage < Damage
    def initialize(amount, damage_dealer)
        super(amount, damage_dealer)
        @damage_type = "skill"
    end
end