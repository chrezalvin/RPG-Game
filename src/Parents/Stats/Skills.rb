require "utils/Event"
require "Parents/Action/Skill"
require "Parents/Creature"

class Skills
    attr_accessor :skills
    attr_reader :skill_modifiers

    # @param skills [Array<Class<Skill>>] the list of skills that the creature can use, stored as classes to be instantiated when used
    # @param skill_owner [Creature] the creature that owns the skills, used for skill modifiers to modify the skill instance when instantiated
    def initialize(skills, skill_owner)
        throw "Error: skill_owner must be an instance of Creature, got #{skill_owner.class}" unless skill_owner.is_a? Creature
        throw "Error: skills must be an array of Skill classes, got #{skills.class}" unless skills.is_a? Array

        @skill_owner = skill_owner
        @skills = skills

        @skill_modifiers = Event.new()
    end

    # @return [Array<Skill>] the instantiated list of skills that the creature can use
    def skills
        skills = []

        @skills.each do |skill_class|
            skill_instance = skill_class.new(@skill_owner)

            @skill_modifiers.emit(skill_instance)

            skills << skill_instance
        end

        return skills
    end
end