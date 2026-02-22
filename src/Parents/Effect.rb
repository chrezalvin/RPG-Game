require_relative "./Damage"
require_relative "./Creature"

class Effect
    class << self
        attr_reader :name, :description
    end

    @name = "unknown effect"
    @description = "unknown description"
    def initialize
        @effect_owner = nil
    end

    def on_before_take_damage(damage)
        throw "damage must be an instance of Damage, got #{damage.class}" unless damage.is_a? Damage
    end
    def on_after_take_damage(damage)
        throw "damage must be an instance of Damage, got #{damage.class}" unless damage.is_a? Damage
    end
    def on_before_deal_damage(damage)
        throw "damage must be an instance of Damage, got #{damage.class}" unless damage.is_a? Damage
    end
    def on_after_deal_damage(damage)
        throw "damage must be an instance of Damage, got #{damage.class}" unless damage.is_a? Damage
    end
    def on_before_heal(heal_amount); end
    def on_after_heal(heal_amount); end
    def on_before_use_skill(skill, target)
        throw "skill must be an instance of Skill, got #{skill.class}" unless skill.is_a? Skill
        throw "target must be an instance of Creature, got #{target.class}" unless target.is_a? Creature
    end
    def on_after_use_skill(skill, target)
        throw "skill must be an instance of Skill, got #{skill.class}" unless skill.is_a? Skill
        throw "target must be an instance of Creature, got #{target.class}" unless target.is_a? Creature
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

    def apply_effect(creature)
        throw "creature must be an instance of Creature, got #{creature.class}" unless creature.is_a? Creature

        creature.apply_effect(self)
        @effect_owner = creature
    end
end