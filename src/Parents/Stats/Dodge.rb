require "Parents/Damage"

class Dodge
    attr_accessor :dodge

    @@min_accuracy_chance_percentage = 20

    # @param dodge [Integer]
    def initialize(dodge: nil)
        @dodge = dodge || 0
    end

    # @param damage [Damage] the damage to be checked for dodging
    # @return [Boolean] true if the damage is dodged, false otherwise
    def can_dodge?(damage)
        throw "Error: damage must be an instance of Damage, got #{damage.class}" unless damage.is_a? Damage

        if damage.accuracy == nil
            return false
        end

        if (@dodge + damage.accuracy) == 0
            return false
        end

        chance = (@dodge / (@dodge + damage.accuracy) * 100).to_i
        
        rand(100) < [@@min_accuracy_chance_percentage, chance].max
    end
end