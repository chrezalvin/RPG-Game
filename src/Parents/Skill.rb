require "colorize"
require "Parents/Creature"

class Skill
    attr_reader :name, :damage, :description

    class << self
        attr_reader :description, :name, :sound_file
    end

    @name = "unknown skill"
    @description = "unknown description"
    @sound_file = nil
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

    def sound_file
        self.class.sound_file
    end

    def name_colorized
        self.class.name.colorize(:light_magenta)  
    end

    def can_use_skill?(creature)
        false
    end

    def use_skill(creature)
        throw "The skill must be used on a Creature. However, it is used on #{creature.class}" unless creature.is_a? Creature

        return can_use_skill?(creature)
    end
end