require "Parents/Effect"

require "Damages/EffectDamage"

class Thorns < Effect
    @damage_fraction_multiplier_percentage = 25
    @initial_durability = 3
    @name = "Thorns"
    @description = "Deals #{@damage_fraction_multiplier_percentage}% damage to the attacker back when the bearer takes damage for #{@initial_durability} times"
    def initialize()
        super()
        @durability = self.class.initial_durability
    end

    def self.damage_fraction_multiplier_percentage
        @damage_fraction_multiplier_percentage
    end
    
    def self.initial_durability
        @initial_durability
    end

    def on_after_take_damage(damage)
        super(damage)
        if damage.damage_dealer != nil
            effectDamage = EffectDamage.new((damage.damage * self.class.damage_fraction_multiplier_percentage / 100).to_i)
            damage.damage_dealer.take_damage(effectDamage)
        end

        @effect_owner.cleanup_expired_effects
    end

    def apply_effect(creature)
        found = creature.find_effect(self.class)

        if found.nil?
            creature.apply_effect(self)
            @effect_owner = creature
        else
            found.add_stack(@stack)
        end
    end

    def is_expired?
        @durability <= 0
    end
end