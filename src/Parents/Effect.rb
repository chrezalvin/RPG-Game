require "Parents/Damage"
require "Parents/Creature"
require "Parents/Heal"
require "Parents/Skill"

require "Parents/Stats/Atk"
require "Parents/Stats/Matk"
require "Parents/Stats/Defense"
require "Parents/Stats/NaturalHpRegen"
require "Parents/Stats/NaturalMpRegen"
require "Parents/Stats/Accuracy"
require "Parents/Stats/Dodge"
require "Parents/Stats/Speed"


class Effect
    attr_reader :effect_owner, :name, :description  
    attr_reader :stack

    class << self
        attr_reader :name, :description
    end

    @name = "unknown effect"
    @description = "unknown description"
    def initialize
        # @type [Creature, nil] the creature that owns this effect
        @effect_owner = nil

        # @type [Integer, nil] the stack of this effect, if applicable. nil if this effect does not use stack
        @stack = nil
    end

    # @param damage [Damage] the damage instance to be modified
    def on_before_take_damage(damage)
        throw "damage must be an instance of Damage, got #{damage.class}" unless damage.is_a? Damage
    end

    # @param damage [Damage] the damage instance to be modified
    def on_after_take_damage(damage)
        throw "damage must be an instance of Damage, got #{damage.class}" unless damage.is_a? Damage
    end

    # @param damage [Damage] the damage instance to be modified
    def on_take_damage_miss(damage)
        throw "damage must be an instance of Damage, got #{damage.class}" unless damage.is_a? Damage
    end

    # @param damage [Damage] the damage instance to be modified
    def on_before_deal_damage(damage)
        throw "damage must be an instance of Damage, got #{damage.class}" unless damage.is_a? Damage
    end

    # @param damage [Damage] the damage instance to be modified
    def on_after_deal_damage(damage)
        throw "damage must be an instance of Damage, got #{damage.class}" unless damage.is_a? Damage
    end

    # @param heal_instance [Heal] the heal instance to be modified
    def on_before_heal(heal_instance)
        throw "heal_instance must be an instance of Heal, got #{heal_instance.class}" unless heal_instance.is_a? Heal
    end

    # @param heal_instance [Heal] the heal instance to be modified
    def on_after_heal(heal_instance)
        throw "heal_instance must be an instance of Heal, got #{heal_instance.class}" unless heal_instance.is_a? Heal
    end

    # @param skill [Skill] the skill instance to be modified
    # @param target [Creature] the target of the skill
    def on_before_use_skill(skill, target)
        throw "skill must be an instance of Skill, got #{skill.class}" unless skill.is_a? Skill
        throw "target must be an instance of Creature, got #{target.class}" unless target.is_a? Creature
    end

    # @param skill [Skill] the skill instance to be modified
    # @param target [Creature] the target of the skill
    def on_after_use_skill(skill, target)
        throw "skill must be an instance of Skill, got #{skill.class}" unless skill.is_a? Skill
        throw "target must be an instance of Creature, got #{target.class}" unless target.is_a? Creature
    end

    # @param atk [Atk] the Atk instance to be modified
    def modify_atk(atk)
        throw "atk must be an Atk, got #{atk.class}" unless atk.is_a? Atk
    end

    # @param matk [Matk] the Matk instance to be modified
    def modify_matk(matk)
        throw "matk must be an Matk, got #{matk.class}" unless matk.is_a? Matk
    end

    # @param matk [Matk] the Matk instance to be modified
    def modify_defense(defense)
        throw "defense must be a Defense, got #{defense.class}" unless defense.is_a? Defense
    end

    # @param natural_hp_regen [NaturalHpRegen] the NaturalHpRegen instance to be modified
    def modify_natural_hp_regen(natural_hp_regen)
        throw "natural_hp_regen must be a NaturalHpRegen, got #{natural_hp_regen.class}" unless natural_hp_regen.is_a? NaturalHpRegen
    end

    # @param natural_mp_regen [NaturalMpRegen] the NaturalMpRegen instance to be modified
    def modify_natural_mp_regen(natural_mp_regen)
        throw "natural_mp_regen must be a NaturalMpRegen, got #{natural_mp_regen.class}" unless natural_mp_regen.is_a? NaturalMpRegen
    end

    # @param accuracy [Accuracy] the Accuracy instance to be modified
    def modify_accuracy(accuracy)
        throw "accuracy must be an Accuracy, got #{accuracy.class}" unless accuracy.is_a? Accuracy
    end

    # @param dodge [Dodge] the Dodge instance to be modified
    def modify_dodge(dodge)
        throw "dodge must be a Dodge, got #{dodge.class}" unless dodge.is_a? Dodge
    end

    # @param speed [Speed] the Speed instance to be modified
    def modify_speed(speed)
        throw "speed must be a Speed, got #{speed.class}" unless speed.is_a? Speed
    end

    def name
        self.class.name
    end

    def description
        self.class.description
    end

    def name_colorized
        self.class.name.colorize(:light_blue)
    end

    def is_expired?
        true
    end

    # @param amount [Integer] the amount of stack to add
    def add_stack(amount)
        unless @stack.nil?
            @stack += amount
        end
    end

    # @param creature [Creature] the creature to apply the effect to
    def apply_effect(creature)
        throw "creature must be an instance of Creature, got #{creature.class}" unless creature.is_a? Creature

        creature.apply_effect(self)
        @effect_owner = creature
    end
end