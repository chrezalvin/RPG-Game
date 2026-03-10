require "Parents/Effect"
require "Heal/RegenerationHeal"

class TransformBatBuff < Effect
    @def_reduction_multiplier_percentage = 50
    @atk_reduction_multiplier_percentage = 50
    @matk_increase_multiplier_percentage = 100
    @dodge_increase_multiplier_percentage = 100
    @damage_increase_multiplier_percentage = 100
    @heal_based_damage_multiplier_percentage = 50
    
    @name = "Transform (Bat)"
    @description = "You're in Bat form, increases Dodge and MATK by 100% in exchange of reduced ATK and DEF by 50%, Damage will be doubled in bat form"
    def initialize()
        super()
        @stack = nil
        @expired = false
    end

    # @param defense [Defense] 
    def modify_defense(defense)
        super(defense)
        defense.defense = (defense.defense * (self.class.def_reduction_multiplier_percentage) / 100).to_i
    end

    # @param atk [Atk]
    def modify_atk(atk)
        super(atk)

        atk.atk_amount = (atk.atk_amount * (100 - self.class.atk_reduction_multiplier_percentage) / 100).to_i
    end

    # @param matk [Matk]
    def modify_matk(matk)
        super(matk)

        matk.matk_amount = (matk.matk_amount * (100 + self.class.matk_increase_multiplier_percentage) / 100).to_i
    end

    def modify_dodge(dodge)
        super(dodge)

        dodge.dodge = (dodge.dodge * (100 + self.class.dodge_increase_multiplier_percentage) / 100).to_i
    end

    # @param damage [Damage] the damage instance to be modified
    def on_before_take_damage(damage)
        super(damage)

        damage.damage = (damage.damage * (100 + self.class.damage_increase_multiplier_percentage) / 100).to_i
    end

    # @param creature [Creature] the creature to apply the effect to
    def apply_effect(creature)
        throw "creature must be an instance of Creature, got #{creature.class}" unless creature.is_a? Creature

        effect = creature.find_effect(self.class)

        if effect == nil
            creature.apply_effect(self)
            creature.on_get_hit do |damage| 
                heal_instance = RegenerationHeal.new((damage.amount * self.class.heal_based_damage_multiplier_percentage / 100).to_i)
                @effect_owner.heal(heal_instance)
            end
        else
            creature.remove_effect(effect)
        end
    end

    def is_expired?
        @expired
    end

    def self.def_reduction_multiplier_percentage
        @def_reduction_multiplier_percentage
    end

    def self.atk_reduction_multiplier_percentage
        @atk_reduction_multiplier_percentage
    end

    def self.matk_increase_multiplier_percentage
        @matk_increase_multiplier_percentage
    end

    def self.dodge_increase_multiplier_percentage
        @dodge_increase_multiplier_percentage
    end

    def self.damage_increase_multiplier_percentage
        @damage_increase_multiplier_percentage
    end
end