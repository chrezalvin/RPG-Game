require "forwardable"
require "colorize"

require "utils/Event"
require "Parents/Stats/Hp"
require "Parents/Stats/Mp"
require "Parents/Stats/Atk"
require "Parents/Stats/Matk"
require "Parents/Stats/NaturalMpRegen"
require "Parents/Stats/NaturalHpRegen"
require "Parents/Stats/Accuracy"
require "Parents/Stats/Dodge"
require "Parents/Stats/Defense"
require "Parents/Stats/Speed"

require "Parents/Damage"
require "Parents/Heal"
require "Parents/Effect"
require "Parents/Skill"
require "Parents/Sound"

# Creature class
class Creature
  extend Forwardable
  
  # always available
  class << self
      attr_reader :description, :name
  end

    attr_reader :name, :usable_skills, :effects, :on_use_skill, 
      
      :on_effect_applied, :on_effect_expired, :on_creature_make_sound, :on_damage_miss,
      :remove_on_use_skill, :remove_on_effect_applied, :remove_on_effect_expired, :remove_on_creature_make_sound, :remove_on_damage_miss,

      :current_hp, :max_hp, :on_heal, :on_get_hit, :on_dead, :on_hp_changed,
      :current_mp, :max_mp, :on_mp_used, :on_mp_added, :on_mp_changed

    def_delegators :@hp, 
      :current_hp, 
      :current_hp_colorized, 
      :max_hp_colorized, 
      :max_hp, 
      :on_take_damage, 
      :on_heal,
      :on_dead, 
      :on_hp_changed
    def_delegators :@mp, 
      :current_mp, 
      :current_mp_colorized, 
      :max_mp_colorized, 
      :max_mp, 
      :on_mp_used, 
      :on_mp_added, 
      :on_mp_changed

    def_delegator :@use_skill_listeners, :subscribe, :on_use_skill
    def_delegator :@on_effect_applied_listeners, :subscribe, :on_effect_applied
    def_delegator :@on_effect_expired_listeners, :subscribe, :on_effect_expired
    def_delegator :@on_creature_make_sound_listeners, :subscribe, :on_creature_make_sound
    def_delegator :@on_damage_miss_listeners, :subscribe, :on_damage_miss

    def_delegator :@use_skill_listeners, :unsubscribe, :remove_on_use_skill
    def_delegator :@on_effect_applied_listeners, :unsubscribe, :remove_on_effect_applied
    def_delegator :@on_effect_expired_listeners, :unsubscribe, :remove_on_effect_expired
    def_delegator :@on_creature_make_sound_listeners, :unsubscribe, :remove_on_creature_make_sound
    def_delegator :@on_damage_miss_listeners, :unsubscribe, :remove_on_damage_miss

    # @return [String] the name of the creature
    def name
      self.class.name
    end

    # @return [String] the description of the creature
    def description
      self.class.description
    end

    # @return [String] the name of the creature in colorized format
    def name_colorized
      self.class.name.to_s.colorize(:light_yellow)
    end

    # @type [String, nil]
    @description = nil

    # @type [String]
    @name = "Unknown Creature"

    # @param hp [Integer] the initial and maximum HP of the creature
    # @param mp [Integer] the initial and maximum MP of the creature
    # @param atk [Integer] the attack stat of the creature
    # @param matk [Integer] the magic attack stat of the creature
    # @param defense [Integer] the defense stat of the creature
    # @param nmpr [Integer] the natural MP regeneration of the creature
    # @param nhpr [Integer] the natural HP regeneration of the creature
    def initialize(
      hp: nil, 
      mp: nil, 
      atk: nil,
      matk: nil, 
      defense: nil,
      nmpr: nil, 
      nhpr: nil,
      acc: nil,
      dodge: nil,
      speed: nil
    )
      @hp = Hp.new(current_hp: hp, max_hp: hp)
      @mp = Mp.new(current_mp: mp, max_mp: mp)

      # @type [Integer]
      @atk = atk
      # @type [Integer]
      @matk = matk
      # @type [Integer]
      @defense = defense
      # @type [Integer]
      @acc = acc
      # @type [Integer]
      @dodge = dodge
      # @type [Integer]
      @nmpr = nmpr
      # @type [Integer]
      @nhpr = nhpr
      # @type [Integer]
      @speed = speed

      # @type [Skill[]]
      @usable_skills = []

      # @type [Effect[]]
      @effects = []

      @use_skill_listeners = Event.new()
      @on_effect_applied_listeners = Event.new()
      @on_effect_expired_listeners = Event.new()
      @on_creature_make_sound_listeners = Event.new()
      @on_damage_miss_listeners = Event.new()
    end

    # @param damage [Damage] the damage to be taken by the creature
    # @return [Damage] the end final damage after applying all effects and defenses
    def take_damage(damage)
      throw "Error: damage must be an instance of Damage, got #{damage.class}" unless damage.is_a? Damage

      if self.dodge.can_dodge?(damage)
        @on_damage_miss_listeners.emit(damage)

        return
      end

      unless damage.is_effect
        @effects.each{|effect| effect.on_before_take_damage(damage)}
      end

      self.defense.apply_defense(damage)

      @hp.take_damage(damage)
      damage.has_effects.each{|effect| effect.apply_effect(self)}

      unless damage.is_effect
        @effects.each{|effect| effect.on_after_take_damage(damage)}
      end

      return damage
    end

    # @param heal_instance [Heal] the heal instance to be applied to the creature
    # @return [Heal] the end final heal instance after applying all effects and healing bonuses
    def heal(heal_instance)
      throw "Error: healInstance must be an instance of Heal, got #{heal_instance.class}" unless heal_instance.is_a? Heal

      unless heal_instance.is_effect
        @effects.each{|effect| effect.on_before_heal(heal_instance)}
      end

      @hp.heal(heal_instance)

      unless heal_instance.is_effect
        @effects.each{|effect| effect.on_after_heal(heal_instance)}
      end

      return heal_instance
    end

    # @param amount [Integer]
    # @return [Integer] the end final MP used after applying all effects and MP cost reductions
    def use_mp(amount)
      @mp.use_mp(amount)

      return amount
    end

    # @return [void]
    def regenerate_mp
      self.natural_mp_regen.regenerate(@mp)
    end

    # @return [void]
    def regenerate_hp
      self.natural_hp_regen.regenerate(@hp)
    end

    # @param effect_class [Class]
    # @return [Effect, nil] the effect instance of the specified class if found, nil otherwise
    def find_effect(effect_class)
      throw "Error: effect_class must be a subclass of Effect, got #{effect_class.class}" unless effect_class.is_a? Class

      # @type [Effect, nil]
      effect = @effects.find{|ele| ele.class == effect_class}

      effect
    end

    # find a skill instance from the usable_skills array by its class, return nil if not found
    # @param skill_class [Class]
    # @return [Integer, nil] the index of the skill in the usable_skills array if found, nil otherwise
    def find_skill(skill_class)
      throw "Error: skill_class must be a subclass of Skill, got #{skill_class.class}" unless skill_class.is_a? Class

      idx = @usable_skills.find_index{|ele| ele.class == skill_class}

      idx
    end

    # use a skill by its instance, this method is unsafe and will not check if the skill is owned by the creature, use with caution
    # @param skill [Skill] the skill to be used
    # @param target [Creature] the target to use the skill on
    # @return [void]
    private def unsafe_use_skill(skill, target)
      throw "Error: skill must be an instance of Skill, got #{skill.class}" unless skill.is_a? Skill
      throw "Error: target must be an instance of Creature, got #{target.class}" unless target.is_a? Creature

      @effects.each{|effect| effect.on_before_use_skill(skill, target)}
      
      @use_skill_listeners.emit(skill, nil)
      skill.use_skill(target)

      @effects.each{|effect| effect.on_after_use_skill(skill, target)}
    end

    # @param idx [Integer] the index of the skill to be used in the usable_skills array
    # @param target [Creature] the target to use the skill on
    # @return [void]
    def use_skill(idx, target)
      throw "Error: skill index must be an integer, got #{idx.class}" unless idx.is_a? Integer
      throw "Error: target must be an instance of Creature, got #{target.class}" unless target.is_a? Creature

      skill = self.skill(idx)

      unless skill.nil?
        self.unsafe_use_skill(skill, target)
      end
    end

    # @param sound [Sound] the sound to be made by the creature
    # @return [Sound] the sound instance
    def make_sound(sound)
      throw "Error: sound must be an instance of Sound, got #{sound.class}" unless sound.is_a? Sound

      @on_creature_make_sound_listeners.emit(sound)

      return sound
    end

    # @param effect [Effect] the effect to be applied to the creature
    # @return [Effect] the effect instance after being applied to the creature
    def apply_effect(effect)
      throw "Error: effect must be an instance of Effect, got #{effect.class}" unless effect.is_a? Effect

      @effects.push(effect)

      @on_effect_applied_listeners.emit(effect)

      return effect
    end

    # @param effect [Effect] the effect to be removed from the creature
    # @return [Effect, nil] the effect instance if it was successfully removed, nil otherwise
    def remove_effect(effect)
      throw "Error: effect must be an instance of Effect, got #{effect.class}" unless effect.is_a? Effect

      removed_effect = @effects.delete(effect)

      if removed_effect
        @on_effect_expired_listeners.emit(removed_effect)
      end

      return removed_effect
    end

    # return [Effect[]] the list of expired effects that were removed from the creature
    def cleanup_expired_effects
      expired_effects = @effects.select{|effect| effect.is_expired?}
      @effects.reject!{|effect| effect.is_expired?}

      expired_effects.each do |effect|
        @on_effect_expired_listeners.emit(effect)
      end

      return expired_effects
    end

    # @param creature [Creature] the creature to decide the next action against
    # @return [Integer, nil] the index of the skill to be used in the usable_skills array, nil if no skill is to be used
    def decide_next_action(creature)
      throw "Error: target must be an instance of Creature, got #{creature.class}" unless creature.is_a? Creature

      # random of skills
      random_idx = rand(0...@usable_skills.length)

      return random_idx
    end

    # @return [Skill[]] the list of skills that can be used by the creature, excluding basic attack
    def skills
      return @usable_skills
    end

    # @param idx [Integer] the index of the skill to be retrieved in the usable_skills array, excluding basic attack
    # @return [Skill] the skill instance
    def skill(idx)
      return @usable_skills[idx]
    end

    # @return [Boolean] true if the creature is dead, false otherwise
    def is_dead?
      @hp.is_dead?
    end

    # @return [Atk] the attack stat of the creature after applying all effects
    def atk
      atk = Atk.new(amount: @atk)

      @effects.each{|effect| effect.modify_atk(atk)}

      atk
    end

    # @return [Matk] the magic attack stat of the creature after applying all effects
    def matk
      matk = Matk.new(amount: @matk)

      @effects.each{|effect| effect.modify_matk(matk)}

      matk
    end

    # @return [Defense] the defense stat of the creature after applying all effects
    def defense
      defense = Defense.new(defense: @defense)

      @effects.each{|effect| effect.modify_defense(defense)}

      defense
    end

    # @return [Accuracy] the accuracy stat of the creature after applying all effects
    def accuracy
      accuracy = Accuracy.new(accuracy: @acc)

      @effects.each{|effect| effect.modify_accuracy(accuracy)}

      accuracy
    end

    # @return [Dodge] the dodge stat of the creature after applying all effects
    def dodge
      dodge = Dodge.new(dodge: @dodge)

      @effects.each{|effect| effect.modify_dodge(dodge)}

      dodge
    end

    # @return [NaturalMpRegen] the natural MP regeneration of the creature after applying all effects
    def natural_mp_regen
      nmpr = NaturalMpRegen.new(natural_mp_regen: @nmpr)

      @effects.each{|effect| effect.modify_natural_mp_regen(nmpr)}

      nmpr
    end

    # @return [NaturalHpRegen] the natural HP regeneration of the creature after applying all effects
    def natural_hp_regen
      nhpr = NaturalHpRegen.new(natural_hp_regen: @nhpr)

      @effects.each{|effect| effect.modify_natural_hp_regen(nhpr)}

      nhpr
    end

    def speed
      speed = Speed.new(speed: @speed)

      @effects.each{|effect| effect.modify_speed(speed)}

      speed
    end
end