require_relative "../Creatures/Creature"

class Skills
    attr_reader :name, :damage, :description

    def initialize(skill_owner)

        if @skill_owner.is_a? Creature
            @skill_owner = skill_owner
        else
            throw "invalid skill owner!"
        end

        @damage = 0
        @name = "unknown skill"
        @description = "unknown description"
    end

    def can_use_skill?(creature)
        false
    end

    def use_skill(creature)
        if creature.is_a? Creature
            
        end
    end
end