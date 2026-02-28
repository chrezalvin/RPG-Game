require "colorize"
require "Parents/Creature"

class Skill
    attr_reader :name, :damage, :description

    class << self
        attr_reader :description, :name, :sound
    end

    @name = "unknown skill"
    @description = "unknown description"
    # @param skill_owner [Creature] the creature that owns the skill
    def initialize(skill_owner)
        throw "skill owner must be a Creature, got #{skill_owner.class}" unless skill_owner.is_a? Creature

        @skill_owner = skill_owner
    end

    def name
        self.class.name
    end

    def description
        self.class.description
    end

    def name_colorized
        self.class.name.colorize(:light_magenta)  
    end

    # check if the skill can be used on the creature
    # @param creature [Creature] the creature to use the skill on
    def can_use_skill?(creature)
        false
    end

    # use the skill on th creature
    # @param creature [Creature] the creature to use the skill on
    def use_skill(creature)
        throw "The skill must be used on a Creature. However, it is used on #{creature.class}" unless creature.is_a? Creature

        return can_use_skill?(creature)
    end
end