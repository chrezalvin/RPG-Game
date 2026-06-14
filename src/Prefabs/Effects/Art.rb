require "Parents/Action/Effect"

class Art < Effect
    attr_reader :stack

    def initialize(stack = 1)
        super(
            name: "Art",
            description: "Gain speed based on amount of stack you have, modify and unlock new skills"
        )
        @stack = stack
    end

    def display_name
        "#{self.name} (#{@stack})"
    end

    def short_display_name
        "Art(#{@stack})"
    end

    # @param creature [Creature] the creature to attach the effect to
    def on_attach(creature)
        super(creature)

        creature.skills.skill_modifiers.subscribe(method(:modify_skills))
        creature.effectable.on_before_effect_applied.subscribe(method(:modify_effects))
        creature.speed.speed_modifiers.push(method(:modify_speed))
    end

    def on_update(effect)
        @stack += effect.stack
    end

    def on_detach(creature)
        creature.skills.skill_modifiers.unsubscribe(method(:modify_skills))
        creature.effectable.on_before_effect_applied.unsubscribe(method(:modify_effects))
        creature.speed.speed_modifiers.delete(method(:modify_speed))
    end

    def modify_skills(skill)
        if skill.is_a?(Parry)
            modify_parry(skill)
        end

        if skill.is_a?(Guard)
            modify_guard(skill)
        end

        if skill.is_a?(HeavySwing)
            if @stack >= 10
                modify_heavy_swing_grand_slam(skill)
            else
                modify_heavy_swing(skill)
            end
        end

        if skill.is_a?(BasicAttack)
            modify_basic_attack(skill)
        end
    end

    def modify_effects(effect)
        if effect.is_a?(Parrying)
            modify_parrying(effect)
        end

        if effect.is_a?(Shielded)
            modify_shielded(effect)
        end
    end

    # add +1 speed for every stack of Art
    def modify_speed(speed)
        return speed + @stack
    end

    # vvv Below is the skills modification vvv

    # @param basic_attack [BasicAttack] the Basic Attack skill instance to be modified
    def modify_basic_attack(basic_attack)
        basic_attack.name = "Basic Attack (Art)"
        basic_attack.description += " (Art: Gain 1 Art stack on use)"
        
        def basic_attack.use_skill(creature)
            use_turn = UseTurn.new(@action_time)

            damage_amount = @skill_owner.atk.atk
            basicDamage = BasicDamage.new(damage_amount, @skill_owner)
            regenerateMpHeal = RegenerationMpHeal.new(@skill_owner)
            art = Art.new(1)

            @skill_owner.turnable.reduce_turn_amount(use_turn)
            @skill_owner.effectable.apply_effect(art)
            creature.damageable.take_damage(basicDamage)
            creature.mp_healable.heal_mp(regenerateMpHeal)
        end
    end

    # @param guard [Guard] the Guard effect instance to be modified
    def modify_guard(guard)
        guard.name = "Guard (Art)"
        guard.description += " (Art: Now doesn't use MP but requires Art stacks)"
        guard.art_requirement = 2

        def guard.can_use_skill?(_)
            art = @skill_owner.effects.find_effect(Art)

            art && art.stack >= @art_requirement && @action_time <= @skill_owner.turns.current_turn
        end

        def guard.name_display
            # @type [Creature]
            skill_owner = @skill_owner
            # @type [Integer]
            action_time = @action_time
            
            self.skill_display_helper(
                skill_name: @name,
                action_time: action_time,
                art_requirement: @art_requirement,
                can_use_skill: can_use_skill?(@skill_owner),
            )
        end

        def guard.use_skill(_)
            use_turn = UseTurn.new(@action_time)
            @skill_owner.turnable.reduce_turn_amount(use_turn)

            effect = Shielded.new()
            @skill_owner.effectable.apply_effect(effect)
        end
    end

    def modify_shielded(shielded)
        shielded.name = "Shielded (Art)"
        shielded.description += " (Art: Gain 1 Art stack when you take damage)"
        
        # @param damage [Damage] the damage instance to be modified
        def shielded.on_before_take_damage(damage)
            # @type [Creature]
            effect_owner = @effect_owner

            damage.damage = (damage.damage * (100 - @damage_reduction_multiplier_percentage) / 100).to_i

            art = Art.new(1)
            effect_owner.effectable.apply_effect(art)

            effect_owner.effectable.remove_effect(self)
        end
    end

    # @param parrying [Parrying] the Parrying effect instance to be modified
    def modify_parrying(parrying)
        parrying.description = "Reduces next damage taken by half then attacks back x times with the amount of Arts you have (max 10 times), removed after parrying or after you use any skill, each attack will give you 1 Art stack if it hits"
        parrying.name= "Parrying (Art)"

        # now uses half of atk instead of full atk
        parrying.attack_multiplier_percentage = 50

        def parrying.short_display_name
            "Pa+"
        end

        # @param damage [Damage] the damage instance to be modified
        def parrying.on_before_take_damage(damage)
            # @type [Creature]
            effect_owner = @effect_owner

            art = effect_owner.effects.find_effect(Art)
            
            if art != nil
                art_stack = art ? [art.stack, 10].min() : 0

                for i in 1..art_stack do
                    parry_damage = EffectDamage.new(self.calculate_damage, effect_owner)
                    damage.damage_dealer.damageable.take_damage(parry_damage)

                    if !parry_damage.is_miss
                        art = Art.new(1)
                        effect_owner.effectable.apply_effect(art)
                    end
                end

                effect_owner.effectable.remove_effect(self)
            end
        end
    end

    # @param parry [Parry] the Parry skill instance to be modified
    # @param owner [Creature] the creature that owns the Parry skill
    def modify_parry(parry)
        parry.name = "Parry (Art)"
        parry.description += " (Art: Now doesn't use MP but requires Art stacks)"

        # modified parry now uses art instead of mp
        def parry.use_skill(_)            
            # @type [Creature]
            skill_owner = @skill_owner

            use_turn = UseTurn.new(@action_time)
            skill_owner.turnable.reduce_turn_amount(use_turn)

            effect = Parrying.new()
            skill_owner.effectable.apply_effect(effect)
        end

        # modified parry can only be used if the creature has enough art stacks
        def parry.can_use_skill?(_)
            # @type [Creature]
            skill_owner = @skill_owner
            # @type [Integer]
            action_time = @action_time
            # @type [Integer]
            art_requirement = @art_requirement

            art = skill_owner.effects.find_effect(Art)

            art && art.stack >= art_requirement && action_time <= skill_owner.turns.current_turn
        end

        def parry.name_display
            # @type [Creature]
            skill_owner = @skill_owner
            # @type [Integer]
            action_time = @action_time

            self.skill_display_helper(
                skill_name: @name,
                action_time: @action_time,
                art_requirement: @art_requirement,
                can_use_skill: can_use_skill?(@skill_owner),
            )
        end
    end

    def modify_heavy_swing(heavy_swing)
        # modified heavy swing now requires 2 arts, doesn't use mp, but requires 2 turns now
        heavy_swing.action_time = 2
        heavy_swing.skill_mp_usage = 0
        heavy_swing.name = "Heavy Swing (Art)"
        heavy_swing.description += " (Art: Now requires 2 Art stacks, doesn't use MP but requires 2 turns to use)"

        # @param creature [Creature] the creature to use the skill on
        def heavy_swing.use_skill(creature)
            use_turn = UseTurn.new(action_time)
            @skill_owner.turnable.reduce_turn_amount(use_turn)

            damage = self.calculate_damage
            skillDamage = SkillDamage.new(damage, @skill_owner)
            skillDamage.has_effects = [ArmorBreak.new()]

            creature.damageable.take_damage(skillDamage)
        end

        def heavy_swing.can_use_skill?(_)
            art = @skill_owner.effects.find_effect(Art)

            art && art.stack >= 2 && @action_time <= @skill_owner.turns.current_turn
        end

        def heavy_swing.name_display
            self.skill_display_helper(
                skill_name: @name,
                action_time: @action_time,
                art_requirement: 2,
                can_use_skill: can_use_skill?(@skill_owner),
            )
        end
    end

    def modify_heavy_swing_grand_slam(heavy_swing)
        heavy_swing.name = "Grand Slam (Art)"
        heavy_swing.description = "An upgraded version of Heavy Swing (Art), uses 5 Art stacks, deals damage based on your art stacks and atk, applies Armor Break on hit"
        heavy_swing.action_time = 1

        def heavy_swing.calculate_damage(creature)
            art = @skill_owner.effects.find_effect(Art)
            art_stack = art ? art.stack : 0

            (@damage_multiplier * @skill_owner.atk.atk * art_stack).to_i
        end

        def heavy_swing.use_skill(creature)
            use_turn = UseTurn.new(action_time)
            use_art = Art.new(-5)
            @skill_owner.turnable.reduce_turn_amount(use_turn)
            @skill_owner.effectable.apply_effect(use_art)

            damage = self.calculate_damage(creature)
            skillDamage = SkillDamage.new(damage, @skill_owner)
            skillDamage.has_effects = [ArmorBreak.new()]

            creature.damageable.take_damage(skillDamage)
        end
        
        def heavy_swing.can_use_skill?(_)
            # needs 10 art stacks to use
            art = @skill_owner.effects.find_effect(Art)
            art && art.stack >= 10 && @action_time <= @skill_owner.turns.current_turn
        end

        def heavy_swing.name_display
            self.skill_display_helper(
                skill_name: @name,
                action_time: @action_time,
                art_requirement: 10,
                art_usage: 5,
                can_use_skill: can_use_skill?(@skill_owner),
            )
        end
    end
end