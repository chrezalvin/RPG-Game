require "Parents/Action/Skill"
require "Effects/TransformBatBuff"

class TransformBat < Skill
    attr_accessor :transform_skill_mp_usage, :transform_back_mp_usage

    def initialize(skill_owner)
        super(
            skill_owner: skill_owner,
            name: "Transform (Bat)",
            description: "Transforms into a Bat, Enhances various stats but halves ATK and DEF and doubles damage taken, use skill again to transform back",
        )

        @transform_skill_mp_usage = 30
        @transform_back_mp_usage = 0
    end

    # @param creature [Creature] the creature to use the skill on
    def use_skill(_creature)
        if !super(creature)
            return
        end

        use_turn = UseTurn.new(@action_time)
        use_mp = MpUse.new(self.mp_usage)

        @skill_owner.turnable.reduce_turn_amount(use_turn)
        @skill_owner.mp_usable.use_mp(use_mp)

        effect = TransformBatBuff.new()

        @skill_owner.effectable.apply_effect(effect)
    end

    def name_display
        self.skill_display_helper(
            skill_name: @name,
            action_time: @action_time,
            skill_mp_usage: self.mp_usage,
            can_use_skill: can_use_skill?(@skill_owner),
        )
    end

    def mp_usage
        if @skill_owner.effects.find_effect(TransformBatBuff)
            @transform_back_mp_usage
        else
            @transform_skill_mp_usage
        end
    end

    # @param creature [Creature] the creature to check if the skill can be used on
    def can_use_skill?(creature)
        throw "creature must be an instance of Creature, got #{creature.class}" unless creature.is_a? Creature

        if creature.find_effect(TransformBatBuff)
            return @skill_owner.mp.current_mp >= @transform_back_mp_usage && self.action_time <= @skill_owner.turns.current_turn
        else
            return @skill_owner.mp.current_mp >= @transform_skill_mp_usage && self.action_time <= @skill_owner.turns.current_turn
        end
    end
end