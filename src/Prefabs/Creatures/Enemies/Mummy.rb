require "Parents/Creature"

require "Skills/BasicAttack"
require "Skills/Curse"
require "Damages/BasicDamage"


class Mummy < Creature
    @name = "Mummy"
    @description = "An undead creature"
    @chance_to_use_skill = 0.7
    def initialize
        super(
            hp: 60,
            mp: 200,
            atk: 5,
            matk: 20,
            nmpr: 20,
            nhpr: 10,
            acc: 10,
            speed: 3
        )
        
        @usable_skills = [
            BasicAttack.new(self),
            Curse.new(self)
        ]
    end

    def self.chance_to_use_skill
        @chance_to_use_skill
    end

    # when mummy gets healed, it will take damage instead
    def heal(heal_instance)
        throw "Error: healInstance must be an instance of Heal, got #{heal_instance.class}" unless heal_instance.is_a? Heal

        damage = BasicDamage.new(heal_instance.heal, heal_instance.healer)

        damage.apply_to(self)
    end

    def decide_next_action(creature)
        super(creature)

        if rand < self.class.chance_to_use_skill
            random_idx = rand(@usable_skills.length)
            skill = self.skill(random_idx)
            if skill.can_use_skill?(creature)
                return random_idx
            end
        end

        return 0
    end
end