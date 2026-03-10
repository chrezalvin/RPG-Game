require "Parents/Damage"

class Defense
    attr_accessor :defense

    # @param defense [Integer]
    def initialize(defense: nil)
        @defense = defense || 0
    end

    # @param damage [Damage] the damage to apply defense to
    # @return [void]
    def apply_defense(damage)
        throw "Error: damage must be an instance of Damage, got #{damage.class}" unless damage.is_a? Damage

        damage.damage = [damage.damage - @defense, 0].max
    end
end