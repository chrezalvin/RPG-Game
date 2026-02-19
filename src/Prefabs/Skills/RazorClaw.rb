require_relative "../../Parents/Skill"

class RazorClaw < Skill

    @@name = "Razor Claw"
    @@description = "Swift slash with her claws, very fast and never misses"
    def initialize(skill_owner)
        super(skill_owner)
    end

    def self.name
        @@name
    end

    def self.description
        @@description
    end
end