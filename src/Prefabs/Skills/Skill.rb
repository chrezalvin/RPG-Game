require_relative "../Creatures/Creature"

class Skill
    attr_reader :name, :damage, :description

    def initialize(skill_owner)
        
        if skill_owner.is_a? Creature
            @skill_owner = skill_owner
        else
            throw "invalid skill owner! skill owner is a #{skill_owner.inspect}"
        end

        @damage = 0
        @name = "unknown skill"
        @description = "unknown description"
    end

    def can_use_skill?(creature)
        false
    end

    def use_skill(creature)
        unless creature.is_a? Creature
            throw "The skill must be used on a Creature. However, it is used on #{creature.class}"
        end
    end
end