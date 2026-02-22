require_relative "./Creature"
require "colorize"

class Skill
    attr_reader :name, :damage, :description

    class << self
        attr_reader :description, :name
    end

    @name = "unknown skill"
    @description = "unknown description"
    def initialize(skill_owner)
        
        if skill_owner.is_a? Creature
            @skill_owner = skill_owner
        else
            throw "invalid skill owner! skill owner is a #{skill_owner.inspect}"
        end
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

    def can_use_skill?(creature)
        false
    end

    def use_skill(creature)
        throw "The skill must be used on a Creature. However, it is used on #{creature.class}" unless creature.is_a? Creature

        return can_use_skill?(creature)
    end
end