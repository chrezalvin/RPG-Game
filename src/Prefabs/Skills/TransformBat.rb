require "Parents/Skill"
require "Effects/TransformBatBuff"

class TransformBat < Skill

    @transform_skill_mp_usage = 30
    @transform_back_mp_usage = 0
    @name = "Transform (Bat)"
    @description = "Transforms into a Bat, increases Dodge and MATK by 100% in exchange of reduced ATK and DEF by 50%, Damage taken will be doubled in bat form, uses #{@transform_skill_mp_usage} mana, use skill back to transform back for free"
    def initialize(skill_owner)
        super(skill_owner)
    end

    def self.transform_skill_mp_usage
        @transform_skill_mp_usage
    end

    def self.transform_back_mp_usage
        @transform_back_mp_usage
    end

    # @param creature [Creature] the creature to check if the skill can be used on
    def can_use_skill?(creature)
        throw "creature must be an instance of Creature, got #{creature.class}" unless creature.is_a? Creature

        if creature.find_effect(TransformBatBuff)
            return @skill_owner.current_mp >= self.class.transform_back_mp_usage
        else
            return @skill_owner.current_mp >= self.class.transform_skill_mp_usage
        end
    end

    # @param creature [Creature] the creature to use the skill on
    def use_skill(_creature)
        if super(@skill_owner)
            if @skill_owner.find_effect(TransformBatBuff)
                @skill_owner.use_mp(self.class.transform_back_mp_usage)
            else
                @skill_owner.use_mp(self.class.transform_skill_mp_usage)
            end

            effect = TransformBatBuff.new()

            effect.apply_effect(@skill_owner)
        end
    end
end