require "Parents/Creature"

require "Skills/HeavySwing"
require "Skills/BasicAttack"
require "Skills/BasicHealing"
require "Skills/Guard"
require "Skills/Parry"
require "Skills/Quicken"
require "Effects/Thorns"
require "Effects/Art"

class Viking < Creature
    attr_accessor :arts

    @description = "An ancient warrior"
    @name = "Viking"
    @chance_to_use_skill = 0.5
    def initialize()
        super(
            hp: 100,
            mp: 80,
            atk: 20,
            matk: 10,
            nmpr: 10,
            nhpr: 10,
            dodge: 10, 
            defense: 7,
            acc: 10,
            speed: 5
        )

        @skills.skills = [
            BasicAttack,
            HeavySwing, 
            Guard,
            Parry,
            BasicHealing,
            Quicken
        ]
        
        @art = Art.new(0)
        @fightable.on_before_fight_start_listeners.subscribe{|_|
            # gain Art buff at the start of fight
            @effectable.apply_effect(@art)
        }

        @fightable.on_after_fight_end_listeners.subscribe{|_|
            # remove all Art stacks at the end of fight
            @effectable.remove_effect(@art)
        }
    end

    def self.chance_to_use_skill
        @chance_to_use_skill
    end

    def decide_next_action(creature)
        super(creature)

        if rand < self.class.chance_to_use_skill
            random_idx = rand(@usable_skills.length)
            skill = skills.fetch(random_idx)
            if skill.can_use_skill?(creature)
                return random_idx
            end
        end

        return 0
    end
end