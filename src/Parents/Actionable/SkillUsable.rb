require "utils/Event"
require "Parents/Action/Skill"
require "Parents/Creature"

class SkillUsable
    attr_reader :on_before_use_skill, :on_after_use_skill

    # @param creature [Creature] the creature that can use skills
    def initialize(creature)
        throw "Error: creature must be an instance of Creature, got #{creature.class}" unless creature.is_a? Creature

        @creature = creature

        @on_before_use_skill = Event.new()
        @on_after_use_skill = Event.new()
    end

    # @param skill [Skill] the skill instance to be used
    # @param target [Creature] the target creature of the skill
    def use_skill(skill, target)
        throw "Error: skill must be an instance of Skill, got #{skill.class}" unless skill.is_a? Skill
        throw "Error: target must be an instance of Creature, got #{target.class}" unless target.is_a? Creature

        return unless skill.can_use_skill?(target)

        @on_before_use_skill.emit(skill, target)

        skill.use_skill(target)

        @on_after_use_skill.emit(skill, target)
    end
end