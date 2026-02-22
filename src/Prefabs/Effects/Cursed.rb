require_relative "../../Parents/Effect"

class Cursed < Effect
    
    @heal_reduction_multiplier = 0.5
    @name = "Cursed"
    @description = "Reduce the next heal received by #{@heal_reduction_multiplier * 100}%"
    def initialize()
        super()
        @is_used = false
    end

    def self.heal_reduction_multiplier
        @heal_reduction_multiplier
    end

    def on_before_heal(heal_instance)
        super(heal_instance)

        heal_instance.heal = (heal_instance.heal * (100 - self.class.heal_reduction_multiplier) / 100).to_i

        @is_used = true

        @effect_owner.cleanup_expired_effects
    end

    def is_expired?
        @is_used
    end
end