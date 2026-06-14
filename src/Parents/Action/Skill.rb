require "colorize"
require "Parents/Creature"
require "Parents/Stats/Turn"

class Skill
    attr_accessor :action_time, :name, :description

    class << self
        attr_reader :sound
    end

    # @param skill_owner [Creature] the creature that owns the skill
    def initialize(
        skill_owner: nil,
        name: "unknown skill",
        description: "unknown description",
        action_time: 1
    )
        throw "skill owner must be a Creature, got #{skill_owner.class}" unless skill_owner.is_a? Creature
        @skill_owner = skill_owner

        @name = name
        @description = description
        @action_time = action_time
    end

    # name of the skill in colorized format, default to light magenta
    def name_colorized
        self.name.colorize(:light_magenta)
    end

    # name of the skill to be displayed in the menu
    def name_display
        self.name_colorized
    end

    def skill_mp_usage
        nil
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

    # normalized display of the skill in the menu
    # @param skill_name [String] the name of the skill, used to display the skill name
    # @param action_time [Integer] the action time of the skill, used to display the turn requirement
    # @param skill_mp_usage [Integer] the MP usage of the skill, used to
    # @param can_use_skill [Boolean] whether the skill can be used, used to display the skill name and MP usage in grey if the skill cannot be used
    # @param art_requirement [Integer] the art requirement of the skill, used to display the art requirement in yellow if the skill cannot be used
    # @param art_usage [Integer] the art usage of the skill, used to display the art usage in yellow if the skill cannot be used
    def skill_display_helper(
        skill_name: nil,
        can_use_skill: nil,
        action_time: nil,
        skill_mp_usage: nil,
        art_requirement: nil,
        art_usage: nil
    )
        skill_usable = can_use_skill.nil? ? self.can_use_skill?(nil) : can_use_skill
        display = ""

        usage = []
        if action_time
            if action_time > 0
                usage << "#{action_time.to_s} trn"
            elsif action_time == 0
                usage << "#{action_time.to_s.colorize(:grey)} trn"
            else
                usage << "+#{action_time.to_s.colorize(:green)} trn"
            end
        end

        if art_usage
            if art_usage > 0
                usage << "#{art_usage.to_s.colorize(:red)} Art"
            elsif art_usage == 0
                usage << "#{art_usage.to_s.colorize(:grey)} Art"
            else
                usage << "+#{art_usage.to_s.colorize(:green)} Art"
            end
        end

        if usage.any?
            display += "(#{usage.join(", ")}) "
        end

        if skill_name
            if skill_usable
                display += skill_name
            else
                display += skill_name.colorize(:grey)
            end
        end

        requirements = []

        if skill_mp_usage
            requirements << "#{@skill_mp_usage.to_s.colorize(:blue)} MP"
        end

        if art_requirement && !skill_usable
            requirements << "Require #{art_requirement.to_s.colorize(:yellow)} Art"
        end

        if requirements.any?
            display += " (#{requirements.join(", ")})"
        end

        display
    end
end